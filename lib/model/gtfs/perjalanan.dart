import '../constant/jenis_perkhidmatan.dart';

enum ArahPerjalanan { satuArah, berbalik }

class Perjalanan {
  String idPerjalanan;
  String idLaluan;
  String idPerkhidmatan;
  String? idBentuk;
  String? petunjukPerjalanan;
  ArahPerjalanan? idArah;

  Perjalanan(
    this.idLaluan,
    this.idPerkhidmatan,
    this.idPerjalanan,
    this.idBentuk,
    this.petunjukPerjalanan,
    this.idArah,
  );

  factory Perjalanan.dariCsv(
          List<dynamic> data, JenisPerkhidmatan perkhidmatan) =>
      switch (perkhidmatan) {
        JenisPerkhidmatan.basPerantaraMrt => Perjalanan(
            data[0].toString(),
            data[1].toString(),
            data[2].toString(),
            data[5] != '' ? data[5].toString() : null,
            data[3] != '' ? data[3].toString() : null,
            _tukar(data[4] as int),
          ),
        JenisPerkhidmatan.basKL => Perjalanan(
            data[0].toString(),
            data[1].toString(),
            data[2] as String,
            data[3] != '' ? data[3].toString() : null,
            data[4] != '' ? data[4].toString() : null,
            _tukar(data[5] as int),
          ),
        JenisPerkhidmatan.relKL => throw UnimplementedError(),
      };

  @override
  String toString() =>
      'Perjalanan{idLaluan: $idLaluan, idPerkhidmatan: $idPerkhidmatan, idPerjalanan: $idPerjalanan, idBentuk: $idBentuk, petunjukPerjalanan: $petunjukPerjalanan, idArah: $idArah}';
}

ArahPerjalanan? _tukar(int? nilai) => switch (nilai) {
      0 => ArahPerjalanan.satuArah,
      1 => ArahPerjalanan.berbalik,
      int() || null => null,
    };
