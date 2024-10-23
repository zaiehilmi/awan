import 'dart:io';

import 'package:awan/database/dao/berkaitan_pemetaanPeta.dart';
import 'package:awan/model/constant/aset_lokal.dart';
import 'package:awan/service/state/vm_lokal.dart';
import 'package:awan/util/extension/string.dart';
import 'package:awan/util/roggle.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:june/state_manager/src/simple/state.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../database/pangkalan_data.dart';
import '../service/state/vm_bas.dart';
import '../util/posisi_semasa.dart';
import '../widget/paparan_ringkas.dart';

class PetaUtama extends HookWidget {
  MapboxMap? petaMapbox;

  final kamera = CameraOptions(
    center: Point(
      coordinates: Position(101.66798127599606, 2.98264014924525),
    ),
    zoom: 14,
  );

  Future<void> onPressGoToCurrentLocation(BuildContext context) async {
    final posisi = await dapatkanPosisiSemasa(context);
    rog.d('posisi semasa: ${posisi?.latitude},${posisi?.longitude}');

    final options = CameraOptions(
      center: Point(
        coordinates: Position(
          posisi?.longitude as num,
          posisi?.latitude as num,
        ),
      ),
      zoom: 14,
    );

    final animasi = MapAnimationOptions(duration: 200, startDelay: 0);
    petaMapbox?.easeTo(options, animasi);
  }

  @override
  Widget build(BuildContext context) {
    final senaraiHentian = useState<List<HentianEntitiData>>([]);
    final basInitialized = useState(false);

    useEffect(() {
      Future<void> initBasState() async {
        final daoPeta = DaoBerkaitanPemetaanPeta(lokalState.db);

        senaraiHentian.value = await daoPeta.dapatkanKoordinatSemuaHentian();

        await basState.masaKetibaan(bas: 'T542');
        await basState.masaKetibaan(bas: 'T818');
        await basState.masaKetibaan(bas: 'T852');

        basInitialized.value = true;
      }

      if (!basInitialized.value) {
        initBasState();
      }

      return null;
    }, [basInitialized.value]); // depend on basInitialized value to run once

    void setingOrnament() {
      final kompas = CompassSettings(
        position: OrnamentPosition.TOP_RIGHT,
        marginTop: MediaQuery.paddingOf(context).top + 30,
        marginRight: 15,
      );

      final skala = ScaleBarSettings(enabled: false);

      if (Platform.isAndroid) {
        petaMapbox?.compass.updateSettings(kompas);
      }
      petaMapbox?.scaleBar.updateSettings(skala);
    }

    void onMapCreated(MapboxMap mapbox) async {
      petaMapbox = mapbox;

      setingOrnament();

      final ikonHentianBas = await AsetLokal.ikonHentianBas.nama.keUint8List;

      petaMapbox?.annotations
          .createPointAnnotationManager()
          .then((manager) async {
        var options = <PointAnnotationOptions>[];

        senaraiHentian.value.forEachIndexed((i, e) {
          options.add(
            PointAnnotationOptions(
              image: ikonHentianBas,
              iconSize: 1.4,
              textField: e.namaHentian,
              textSize: 0,
              geometry: Point(
                coordinates: Position(e.lon as num, e.lat as num),
              ),
            ),
          );
        });

        manager.createMulti(options);
        manager.addOnPointAnnotationClickListener(PointTapListener());
      });
    }

    if (senaraiHentian.value.isEmpty) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    return Stack(
      children: [
        MapWidget(
          cameraOptions: kamera,
          onMapCreated: onMapCreated,
        ),
        Positioned(
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SafeArea(
              child: FButton.icon(
                style: FButtonStyle.secondary,
                onPress: () => onPressGoToCurrentLocation(context),
                child: FIcon(FAssets.icons.locate),
              ),
            ),
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.8,
          snap: true,
          snapSizes: const [.3, .5],
          builder: (BuildContext context, ScrollController scrollController) {
            return !basInitialized.value
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  ) // Show loading while waiting
                : JuneBuilder(
                    () => BasVM(),
                    builder: (vm) => SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        color: Colors.black54,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PaparanRingkas(
                              kodLaluan: 'T542',
                              namaLaluan: 'Rumah',
                              listJadual: vm.senaraiLaluan
                                  .where((e) => e.kodLaluan == 'T542')
                                  .first
                                  .jadual,
                              onTap: () async {
                                print('lala');
                              },
                            ),
                            const Gap(10),
                            PaparanRingkas(
                              kodLaluan: 'T818',
                              namaLaluan: 'Gi Office 😭',
                              listJadual: vm.senaraiLaluan
                                  .where((e) => e.kodLaluan == 'T818')
                                  .first
                                  .jadual,
                            ),
                            const Gap(10),
                            PaparanRingkas(
                              kodLaluan: 'T852',
                              namaLaluan: 'Gi Office 😭',
                              listJadual: vm.senaraiLaluan
                                  .where((e) => e.kodLaluan == 'T852')
                                  .first
                                  .jadual,
                            ),
                            if (kDebugMode)
                              FButton(
                                label: const Text('Button'),
                                onPress: () async {
                                  final lala =
                                      DaoBerkaitanPemetaanPeta(lokalState.db);
                                  final data1 =
                                      await lala.lukisLaluanBerdasarkan(
                                          kodLaluan: 't542');
                                  print(data1?.length);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }
}

class PointTapListener extends OnPointAnnotationClickListener {
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    rog.i('Tekan pada ${annotation.textField}');
  }
}
