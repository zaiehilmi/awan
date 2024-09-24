import 'package:awan/util/titik_tengah_koordinat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../database/dao/berkaitan_pemetaanPeta.dart';
import '../../service/state/vm_lokal.dart';

class PetaLaluan extends HookWidget {
  final String kodLaluan;
  MapboxMap? petaMapbox;
  PolylineAnnotationManager? polyManager;

  PetaLaluan({super.key, required this.kodLaluan});

  void _ciptaPolyline(ValueNotifier<List<Position>> lukis) {
    petaMapbox?.annotations
        .createPolylineAnnotationManager()
        .then((manager) async {
      polyManager = manager;
      final lineString = PolylineAnnotationOptions(
        geometry: LineString(coordinates: lukis.value),
      );

      polyManager?.createMulti([lineString]);

      polyManager
          ?.addOnPolylineAnnotationClickListener(AnnotationClickListener());
    });
  }

  @override
  Widget build(BuildContext context) {
    final lukis = useState<List<Position>>([]);

    final kamera = CameraOptions(
      center: Point(
        coordinates: titikTengahKoordinat(lukis.value),
      ),
      zoom: 13.5,
    );

    useEffect(() {
      Future<void> runAsync() async {
        final daoPeta = DaoBerkaitanPemetaanPeta(lokalState.db);

        lukis.value =
            await daoPeta.lukisLaluanBerdasarkan(kodLaluan: kodLaluan) ?? [];
      }

      runAsync();

      return null;
    }, []);

    void onMapCreated(MapboxMap mapbox) async {
      petaMapbox = mapbox;

      _ciptaPolyline(lukis);
    }

    if (lukis.value.isEmpty) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    return MapWidget(
      cameraOptions: kamera,
      onMapCreated: onMapCreated,
    );
  }
}

class AnnotationClickListener extends OnPolylineAnnotationClickListener {
  @override
  void onPolylineAnnotationClick(PolylineAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}
