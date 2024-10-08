import '../constant/jenis_perkhidmatan.dart';

enum Ketersediaan { ya, tidak }

/// diambil daripada calendar.txt
class Kalendar {
  String idPerkhidmatan;
  Ketersediaan isnin;
  Ketersediaan selasa;
  Ketersediaan rabu;
  Ketersediaan khamis;
  Ketersediaan jumaat;
  Ketersediaan sabtu;
  Ketersediaan ahad;
  DateTime tarikhMula;
  DateTime tarikhTamat;

  Kalendar(
    this.idPerkhidmatan,
    this.isnin,
    this.selasa,
    this.rabu,
    this.khamis,
    this.jumaat,
    this.sabtu,
    this.ahad,
    this.tarikhMula,
    this.tarikhTamat,
  );

  factory Kalendar.dariCsv(List<dynamic> data, JenisPerkhidmatan perkhidmatan) {
    return Kalendar(
      data[0].toString(),
      _tukar(data[1]),
      _tukar(data[2]),
      _tukar(data[3]),
      _tukar(data[4]),
      _tukar(data[5]),
      _tukar(data[6]),
      _tukar(data[7]),
      DateTime.parse(data[8].toString()),
      DateTime.parse(data[9].toString()),
    );
  }

  @override
  String toString() =>
      'Kalendar{id: $idPerkhidmatan, isnin: $isnin, selasa: $selasa, rabu: $rabu, khamis: $khamis, jumaat: $jumaat, sabtu: $sabtu, ahad: $ahad, tarikhMula: $tarikhMula, tarikhAkhir: $tarikhTamat}';
}

Ketersediaan _tukar(int nilai) => switch (nilai) {
      1 => Ketersediaan.ya,
      int() => Ketersediaan.tidak,
    };
