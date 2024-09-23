import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class PetaMapbox extends HookWidget {
  PetaMapbox({super.key});

  late final MapboxMap? petaMapbox;

  void _onMapCreated(MapboxMap mapbox) {
    petaMapbox = mapbox;
  }

  final kamera = CameraOptions(
    center: Point(
      coordinates: Position(101.66798127599606, 2.98264014924525),
    ),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      cameraOptions: kamera,
      onMapCreated: _onMapCreated,
    );
  }
}
