import 'package:awan/util/roggle.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Future<void> memulakanMapbox() async {
  final token = dotenv.env['MAPBOX_PUBLIC_TOKEN'];

  if (token != null) {
    MapboxOptions.setAccessToken(token);
  } else {
    rog.e('Token untuk akses Mapbox tidak ditemui');
  }
}
