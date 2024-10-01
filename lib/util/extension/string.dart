import 'package:flutter/services.dart';

/// String dalam bahasa Melayu ialah rentetan
extension Rentetan on String {
  String get txt => '$this.txt';

  DateTime get keDateTime {
    final harini = DateTime.now();
    var tarikh = this;

    if (length != 8) tarikh = '0$this';
    String formattedBulan =
        harini.month < 10 ? '0${harini.month}' : harini.month.toString();
    String formattedHari =
        harini.day < 10 ? '0${harini.day}' : harini.day.toString();

    return DateTime.parse(
        '${harini.year}-$formattedBulan-$formattedHari $tarikh');
  }

  String? get jadiNullJikaTiadaData => this != '' ? this : null;

  String get hurufPertamaBesar => this[0].toUpperCase() + substring(1);

  Future<Uint8List> get keUint8List async {
    final byteData = await rootBundle.load(this);
    final imageBytes = byteData.buffer.asUint8List();

    return imageBytes;
  }

  List<dynamic> get keRgbGeoJson {
    // Buang '#' jika ada pada awal string hex
    String hex = replaceAll('#', '');

    // Tukar hex kepada integer
    if (hex.length == 6) {
      return [
        'rgb',
        int.parse(hex.substring(0, 2), radix: 16), // Merah (R)
        int.parse(hex.substring(2, 4), radix: 16), // Hijau (G)
        int.parse(hex.substring(4, 6), radix: 16), // Biru (B)
      ];
    } else if (hex.length == 3) {
      // Format hex 3 digit, contohnya '#FFF'
      return [
        'rgb',
        int.parse(hex[0] * 2, radix: 16), // Merah (R)
        int.parse(hex[1] * 2, radix: 16), // Hijau (G)
        int.parse(hex[2] * 2, radix: 16), // Biru (B)
      ];
    } else {
      throw const FormatException("Kod hex tidak sah");
    }
  }
}
