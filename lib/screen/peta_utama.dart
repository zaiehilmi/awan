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

class PetaUtama extends HookWidget implements OnPointAnnotationClickListener {
  MapboxMap? petaMapbox;
  PointAnnotationManager? pointManager;

  // MARK: Komponen UI 🖼️

  final kamera = CameraOptions(
    center: Point(
      coordinates: Position(101.66798127599606, 2.98264014924525),
    ),
  );

  void setingOrnament(BuildContext context) {
    // kompas
    if (Platform.isAndroid) {
      petaMapbox?.compass.updateSettings(CompassSettings(
        position: OrnamentPosition.TOP_RIGHT,
        marginTop: MediaQuery.paddingOf(context).top + 30,
        marginRight: 15,
      ));
    }

    // skala
    petaMapbox?.scaleBar.updateSettings(ScaleBarSettings(
      enabled: false,
    ));

    // atribut
    petaMapbox?.attribution.updateSettings(AttributionSettings(
      enabled: false,
    ));

    // logo
    petaMapbox?.logo.updateSettings(LogoSettings(
      position: OrnamentPosition.TOP_LEFT,
      marginLeft: 10,
    ));
  }

  Future<void> ciptaPoint(List<HentianEntitiData> senarai) async {
    final ikonHentianBas = await AsetLokal.ikonHentianBas.nama.keUint8List;

    petaMapbox?.annotations
        .createPointAnnotationManager()
        .then((manager) async {
      var options = <PointAnnotationOptions>[];

      senarai.forEachIndexed((i, e) {
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
      manager.addOnPointAnnotationClickListener(this);
    });
  }

  // MARK: Interaksi 🫵

  Future<void> pergiKePosisiSemasa(BuildContext context) async {
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

  // MARK: Kitar hayat luaran ⭕️

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    rog.i('Tekan pada ${annotation.textField}');
  }

  @override
  Widget build(BuildContext context) {
    final senaraiHentian = useState<List<HentianEntitiData>>([]);
    final basInitialized = useState(false);
    final widgetHeight = useState(.0);
    final fabPosition = useState(.0);
    final dragScrollSheetExtent = useState(.0);
    final initialSheetChildSize = useState(.3);

    // MARK: Kitar hayat dalaman 🔴

    useEffect(() {
      Future<void> initBasState() async {
        final daoPeta = DaoBerkaitanPemetaanPeta(lokalState.db);

        senaraiHentian.value = await daoPeta.dapatkanKoordinatSemuaHentian();

        await basState.masaKetibaan(bas: 'T542');
        await basState.masaKetibaan(bas: 'T818');
        await basState.masaKetibaan(bas: 'T852');

        basInitialized.value = true;
      }

      pergiKePosisiSemasa(context);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        fabPosition.value = initialSheetChildSize.value * context.size!.height;
      });

      if (!basInitialized.value) {
        initBasState();
      }

      return null;
    }, [basInitialized.value]); // depend on basInitialized value to run once

    void onMapCreated(MapboxMap mapbox) async {
      petaMapbox = mapbox;

      setingOrnament(context);
      ciptaPoint(senaraiHentian.value);
    }

    // MARK: Mula membina 📦

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
          right: 15,
          bottom: fabPosition.value + 10,
          child: FButton.icon(
            style: FButtonStyle.secondary,
            onPress: () => pergiKePosisiSemasa(context),
            child: FIcon(
              FAssets.icons.locate,
              size: 28,
            ),
          ),
        ),
        NotificationListener<DraggableScrollableNotification>(
          onNotification: (DraggableScrollableNotification notification) {
            widgetHeight.value = context.size?.height ?? 0.0;
            dragScrollSheetExtent.value = notification.extent;

            fabPosition.value =
                dragScrollSheetExtent.value * widgetHeight.value;

            return true;
          },
          child: DraggableScrollableSheet(
            initialChildSize: initialSheetChildSize.value,
            minChildSize: .1,
            maxChildSize: .8,
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
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
                                onTap: () async {},
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
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
