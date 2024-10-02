import 'dart:convert';

import 'package:awan/util/extension/string.dart';
import 'package:awan/util/roggle.dart';
import 'package:awan/util/titik_tengah_koordinat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../database/dao/berkaitan_pemetaanPeta.dart';
import '../../service/state/vm_lokal.dart';

class PetaLaluan extends HookWidget
    implements OnPolylineAnnotationClickListener {
  final String kodLaluan;
  MapboxMap? petaMapbox;
  PolylineAnnotationManager? polyManager;

  PetaLaluan({super.key, required this.kodLaluan});

  @override
  void onPolylineAnnotationClick(PolylineAnnotation annotation) {
    rog.d("onAnnotationClick, id: ${annotation.id}");
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

    Future<void> ciptaPolyline(ValueNotifier<List<Position>> lukis) async {
      if (petaMapbox == null) return;

      polyManager =
          await petaMapbox?.annotations.createPolylineAnnotationManager();
      polyManager?.addOnPolylineAnnotationClickListener(this);

      // Menukar koordinat kepada format GeoJSON yang betul
      List<List<double>> geometry = lukis.value
          .map((position) => [position.lng as double, position.lat as double])
          .toList();

      // Tambah sumber GeoJson ke dalam style peta
      await petaMapbox?.style.addSource(GeoJsonSource(
        id: 'route-source',
        data: jsonEncode({
          "type": "Feature",
          "geometry": {
            "type": "LineString",
            "coordinates": geometry,
          }
        }),
        lineMetrics: true, // Penting untuk gradient
      ));

      // Tambah lapisan dengan kesan gradient ke atas polyline
      await petaMapbox?.style.addLayer(LineLayer(
        id: 'route-layer',
        sourceId: 'route-source',
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
        lineBlur: 1.0,
        lineWidth: 7.5,
        lineOpacity: 0.6,
        lineColor: Colors.white70.value,
        minZoom: 13,
        lineGradientExpression: [
          "interpolate",
          ["linear"],
          ["line-progress"],
          0.0,
          "#FD6585".keRgbGeoJson,
          1.0,
          '#0D25B9'.keRgbGeoJson
        ],
      ));
    }

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

      await ciptaPolyline(lukis);
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
