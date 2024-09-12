import 'package:intl/intl.dart';

extension FormatMasa on DateTime {
  String get format24Jam => DateFormat('HH:mm').format(this);

  bool get iaSelepasSekarang {
    final sekarang = DateTime.now();

    final masaKetibaanSahaja = DateTime(2000, 1, 1, hour, minute, second);
    final masaSekarangSahaja = DateTime(2000, 1, 1, sekarang.hour, sekarang.minute, sekarang.second);

    return masaKetibaanSahaja.isAfter(masaSekarangSahaja);
  }

  Duration get perbezaanMasa {
    final sekarang = DateTime.now();

    final masaKetibaanSahaja = DateTime(2000, 1, 1, hour, minute, second);
    final masaSekarangSahaja = DateTime(2000, 1, 1, sekarang.hour, sekarang.minute, sekarang.second);

    return masaKetibaanSahaja.difference(masaSekarangSahaja);
  }
}
