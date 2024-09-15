import 'package:awan/util/roggle.dart';
import 'package:drift/drift.dart';

import '../../jadual.dart';
import '../../pangkalan_data.dart';

part 'perjalanan.g.dart';

@DriftAccessor(tables: [PerjalananEntiti])
class PerjalananDao //
    extends DatabaseAccessor<PangkalanDataApl> with _$PerjalananDaoMixin {
  PerjalananDao(super.db);

  /// dapatkan 1 baris [PerjalananEntitiData]
  ///
  ///
  Future<PerjalananEntitiData?> dapatkanMelalui({
    required String idPerjalanan,
  }) async {
    final query = select(perjalananEntiti)
      ..where((p) => p.idPerjalanan.equals(idPerjalanan));

    return await query.getSingleOrNull();
  }

  /// dapatkan semua [PerjalananEntitiData].
  ///
  /// > Jika hanya ingin menggunakan [idPerjalanan], pertimbangkan untuk menggunakan [dapatkanMelalui].
  ///
  /// Parameter boleh diumpuk iaitu syarat pencarian tidak terhad untuk 1 syarat
  /// sahaja tetapi untuk [idPerjalanan], query limit akan ditetapkan kepada 1
  /// baris sahaja kerana [idPerjalanan] ialah kunci primer (primary key).
  ///
  /// Sebagai contoh, jika anda
  /// - memberikan [idPerjalanan] dan [idLaluan], syarat pencarian akan
  /// diumpuk untuk mendapatkan 1 baris data.
  /// - memberikan [idLaluan] akan memberikan banyak baris data
  Future<List<PerjalananEntitiData>?> dapatkanSemuaMelalui({
    String? idPerjalanan,
    String? idPerkhidmatan,
    String? idLaluan,
    PerjalananEntitiData? dataPerjalanan,
  }) async {
    if (idPerjalanan != null && idPerkhidmatan == null && idLaluan == null) {
      rog.w(
          'Disarankan untuk menggunakan fungsi `dapatkanMelalui` untuk satu entiti.');
    }
    final query = select(perjalananEntiti);

    if (idPerjalanan != null) {
      query
        ..where((p) => p.idPerjalanan.equals(idPerjalanan))
        ..limit(1);
    }
    if (idPerkhidmatan != null) {
      query.where((p) => p.idPerkhidmatan.equals(idPerkhidmatan));
    }
    if (idLaluan != null) {
      query.where((p) => p.idLaluan.equals(idLaluan));
    }
    if (dataPerjalanan != null) {
      query.whereSamePrimaryKey(dataPerjalanan);
    }

    if (idPerjalanan == null &&
        idPerkhidmatan == null &&
        idLaluan == null &&
        dataPerjalanan == null) {
      throw ArgumentError(
          'Perlu sekurang-kurangnya memberikan `idPerjalanan`, `idPerkhidmatan`, `idLaluan`, atau `dataPerjalanan`');
    }

    return await query.get();
  }
}
