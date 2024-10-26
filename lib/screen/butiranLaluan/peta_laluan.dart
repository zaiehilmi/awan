import 'dart:convert';
import 'dart:io';

import 'package:awan/util/extension/string.dart';
import 'package:awan/util/roggle.dart';
import 'package:awan/util/titik_tengah_koordinat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../database/dao/berkaitan_pemetaanPeta.dart';
import '../../service/state/vm_lokal.dart';

class PetaLaluan extends HookWidget
    implements OnPolylineAnnotationClickListener {
  final String kodLaluan;

  late MapboxMap petaMapbox;
  PolylineAnnotationManager? polyManager;

  PetaLaluan({super.key, required this.kodLaluan});

  // MARK: Komponen UI 🖼

  CameraOptions kameraKeTitikTengah(List<Position> senarai) => CameraOptions(
        center: Point(
          coordinates: titikTengahKoordinat(senarai),
        ),
        zoom: 13.5,
      );

  Future<void> ciptaPolyline(ValueNotifier<List<Position>> lukis) async {
    polyManager =
        await petaMapbox.annotations.createPolylineAnnotationManager();
    polyManager?.addOnPolylineAnnotationClickListener(this);

    // Menukar koordinat kepada format GeoJSON yang betul
    List<List<double>> geometry = lukis.value
        .map((position) => [position.lng as double, position.lat as double])
        .toList();

    final lapisanGarisan = LineLayer(
      id: 'route-layer',
      sourceId: 'route-source',
      lineCap: LineCap.ROUND,
      lineJoin: LineJoin.ROUND,
      lineBlur: 0.8,
      lineWidth: 7.5,
      lineOpacity: 0.6,
      minZoom: 10,
      lineGradientExpression: [
        "interpolate",
        ["linear"],
        ["line-progress"],
        0.0,
        "#FD6585".keRgbGeoJson,
        1.0,
        '#0D25B9'.keRgbGeoJson
      ],
    );

    final sumberGeojson = GeoJsonSource(
      id: 'route-source',
      data: jsonEncode({
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": geometry,
        }
      }),
      lineMetrics: true, // Penting untuk gradient
    );

    await Future.delayed(const Duration(milliseconds: 300));

    // Tambah lapisan dengan kesan gradient ke atas polyline
    await petaMapbox.style.addLayer(lapisanGarisan);
    await petaMapbox.style.addSource(sumberGeojson);
  }

  void setingOrnament(BuildContext context) {
    final kompas = CompassSettings(
      position: OrnamentPosition.TOP_RIGHT,
      marginTop: MediaQuery.paddingOf(context).top + 30,
      marginRight: 15,
    );

    final skala = ScaleBarSettings(enabled: false);

    if (Platform.isAndroid) {
      petaMapbox.compass.updateSettings(kompas);
    }
    petaMapbox.scaleBar.updateSettings(skala);
  }

  // MARK: Interaksi 🫵

  // MARK: Logik 🎨

  // MARK: Kitar hayat luaran ⭕

  @override
  void onPolylineAnnotationClick(PolylineAnnotation annotation) {
    rog.d("onAnnotationClick, id: ${annotation.id}");
  }

  @override
  Widget build(BuildContext context) {
    final lukis = useState<List<Position>>([]);

    // MARK: Kitar hayat dalaman 🔴

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

      setingOrnament(context);
      await ciptaPolyline(lukis);
    }

    // MARK: Mula membina 📦

    if (lukis.value.isEmpty) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    return MapWidget(
      cameraOptions: kameraKeTitikTengah(lukis.value),
      onMapCreated: onMapCreated,
    );
  }
}
