import 'package:intl/intl.dart';

extension FormatMasa on DateTime {
  /// tukar dari DateTime ke String dalam format 24 jam.
  String get format24Jam => DateFormat('HH:mm').format(this);

  /// untuk menentukan jika masa itu ada selepas masa sekarang. Pemalam ini mengabaikan tarikh
  bool get iaSelepasSekarang {
    final sekarang = DateTime.now();

    final masaKetibaanSahaja = DateTime(2_000, 1, 1, hour, minute, second);
    final masaSekarangSahaja = DateTime(
      2000,
      1,
      1,
      sekarang.hour,
      sekarang.minute,
      sekarang.second,
    );

    return masaKetibaanSahaja.isAfter(masaSekarangSahaja);
  }

  /// mendapatkan perbezaan masa dalam [Duration]. Pemalam ini mengabaikan tarikh
  Duration get perbezaanMasa {
    final sekarang = DateTime.now();

    final masaKetibaanSahaja = DateTime(2_000, 1, 1, hour, minute, second);
    final masaSekarangSahaja = DateTime(
      2_000,
      1,
      1,
      sekarang.hour,
      sekarang.minute,
      sekarang.second,
    );

    return masaKetibaanSahaja.difference(masaSekarangSahaja);
  }

  DateTime get tarikhTanpaMasa => DateTime(year, month, day);
}
