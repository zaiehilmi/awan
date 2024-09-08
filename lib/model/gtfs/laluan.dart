import '../constant/jenis_perkhidmatan.dart';

enum JenisKenderaan {
  tram,
  relBawahTanah,
  rel,
  bas,
  feri,
  tramBerkabel,
  lifUdara,
  keretaApiBukit,
  basElektrik,
  monorel
}

/// diambil daripada routes.txt
class Laluan {
  String idLaluan; // digunakan di Perjalanan
  String? idAgensi;
  String? namaPendek;
  String namaPenuh;
  JenisKenderaan jenisKenderaan;
  String? warnaLaluan;
  String? warnaTeksLaluan;

  Laluan(
    this.idLaluan,
    this.idAgensi,
    this.namaPendek,
    this.namaPenuh,
    this.jenisKenderaan,
    this.warnaLaluan,
    this.warnaTeksLaluan,
  );

  factory Laluan.dariCsv(List<dynamic> data, JenisPerkhidmatan perkhidmatan) =>
      switch (perkhidmatan) {
        JenisPerkhidmatan.basPerantaraMrt => Laluan(
            data[0].toString(),
            data[1] == '' ? null : data[1],
            data[2] == '' ? null : data[2],
            data[3],
            _tukar(data[4]),
            null,
            null,
          ),
        JenisPerkhidmatan.basKL || JenisPerkhidmatan.relKL => Laluan(
            data[0],
            data[1],
            data[2].toString(),
            data[3],
            _tukar(data[4]),
            data[5].toString(),
            data[6].toString(),
          ),
      };

  @override
  String toString() {
    return 'Laluan{id: $idLaluan, idAgensi: $idAgensi, namaPendek: $namaPendek, namaPenuh: $namaPenuh, jenisLaluan: $jenisKenderaan, warnaLaluan: $warnaLaluan, warnaTeksLaluan: $warnaTeksLaluan}';
  }
}

JenisKenderaan _tukar(int nilai) => switch (nilai) {
      0 => JenisKenderaan.tram,
      1 => JenisKenderaan.relBawahTanah,
      2 => JenisKenderaan.rel,
      3 => JenisKenderaan.bas,
      12 => JenisKenderaan.monorel,
      int() => JenisKenderaan.feri
    };
