import 'package:awan/util/roggle.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Position titikTengahKoordinat(List<Position> senarai) {
  num jumlahLat = 0;
  num jumlahLon = 0;

  for (var p in senarai) {
    jumlahLon += p.lng;
    jumlahLat += p.lat;
  }

  final saiz = senarai.length;
  final purataLat = jumlahLat / saiz;
  final purataLon = jumlahLon / saiz;

  rog.i('Titik tengah: $purataLat, $purataLon');
  return Position(purataLon, purataLat);
}
