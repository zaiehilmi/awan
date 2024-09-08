import '../constant/jenis_perkhidmatan.dart';

class Hentian {
  String idHentian; // digunakan di WaktuBerhenti
  String? namaHentian;
  String? huraianHentian;
  double? lat;
  double? lon;

  Hentian(this.idHentian, this.namaHentian, this.huraianHentian, this.lat,
      this.lon);

  factory Hentian.dariCsv(List<dynamic> data, JenisPerkhidmatan perkhidmatan) =>
      Hentian(
        data[0].toString(),
        data[1] as String,
        data[2] != '' ? data[2].toString() : null,
        data[3] as double,
        data[4] as double,
      );

  @override
  String toString() =>
      'Hentian{idHentian: $idHentian, namaHentian: $namaHentian, huraianHentian: $huraianHentian, lat: $lat, lon: $lon}';
}

// [1000002, SL254 PERINDUSTRIAN BT CAVES, JLN SBC 5, 3.2336025134884, 101.68713320744]
// [1000068, PROTON (OPP),  JLN MERU, 3.1134794290864, 101.44136018059]
