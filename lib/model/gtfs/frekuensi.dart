import 'package:awan/util/extension/string.dart';

import '../constant/jenis_perkhidmatan.dart';

enum TepatMasa { berasaskanFrekuensi, berasaskanJadual }

/// diambil daripada frequencies.txt
class Frekuensi {
  /// ID Asing yang diambil dari Perjalanan.idPerjalanan
  String idPerjalanan;
  DateTime masaMula;
  DateTime masaTamat;
  int headwaySecs;
  TepatMasa? exactTimes;

  Frekuensi(
    this.idPerjalanan,
    this.masaMula,
    this.masaTamat,
    this.headwaySecs,
    this.exactTimes,
  );

  factory Frekuensi.dariCsv(
          List<dynamic> data, JenisPerkhidmatan perkhidmatan) =>
      Frekuensi(
        data[0],
        data[1].toString().keDateTime,
        data[2].toString().keDateTime,
        data[3],
        tukar(data[4]),
      );

  @override
  String toString() {
    return 'Frekuensi{idPerjalanan: $idPerjalanan, masaMula: $masaMula, masaTamat: $masaTamat, headwaySecs: $headwaySecs, exactTimes: $exactTimes}';
  }
}

TepatMasa? tukar(int? nilai) => switch (nilai) {
      0 || null => TepatMasa.berasaskanFrekuensi,
      int() => TepatMasa.berasaskanJadual,
    };
