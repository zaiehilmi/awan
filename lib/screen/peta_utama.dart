import 'package:awan/database/dao/berkaitan_pemetaanPeta.dart';
import 'package:awan/model/constant/aset.dart';
import 'package:awan/service/state/vm_lokal.dart';
import 'package:awan/util/extension/string.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/assets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../database/pangkalan_data.dart';

class PetaUtama extends HookWidget {
  late final MapboxMap? petaMapbox;

  final kamera = CameraOptions(
    center: Point(
      coordinates: Position(101.66798127599606, 2.98264014924525),
    ),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    final senaraiHentian = useState<List<HentianEntitiData>>([]);

    useEffect(() {
      Future<void> runAsync() async {
        final daoPeta = DaoBerkaitanPemetaanPeta(lokalState.db);

        senaraiHentian.value = await daoPeta.dapatkanKoordinatSemuaHentian();
      }

      runAsync();

      return null;
    }, []);

    void onMapCreated(MapboxMap mapbox) async {
      petaMapbox = mapbox;

      final ikonHentianBas = await AsetLokal.ikonHentianBas.nama.keUint8List;

      petaMapbox?.annotations
          .createPointAnnotationManager()
          .then((manager) async {
        var options = <PointAnnotationOptions>[];

        senaraiHentian.value.forEachIndexed((i, e) {
          options.add(
            PointAnnotationOptions(
              image: ikonHentianBas,
              geometry: Point(
                coordinates: Position(e.lon as num, e.lat as num),
              ),
            ),
          );
        });

        manager.createMulti(options);
      });
    }

    if (senaraiHentian.value.isEmpty) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    return Stack(
      children: [
        // Map Widget
        MapWidget(
          cameraOptions: kamera,
          onMapCreated: onMapCreated,
        ),
        // Draggable Scrollable Sheet
        DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.8,
          snap: true,
          snapSizes: const [.3, .5, .8],
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              height: 400,
              color: Colors.white,
              child: IconButton(
                onPressed: () {},
                icon: FAssets.icons.angry(),
              ),
            );
          },
        ),
      ],
    );
  }
}
