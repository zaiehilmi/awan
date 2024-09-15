import 'package:awan/database/pangkalan_data.dart';
import 'package:drift/drift.dart';

import '../../jadual.dart';

part 'waktu_berhenti.g.dart';

@DriftAccessor(tables: [WaktuBerhentiEntiti])
class WaktuBerhentiDao //
    extends DatabaseAccessor<PangkalanDataApl> with _$WaktuBerhentiDaoMixin {
  WaktuBerhentiDao(super.db);

  /// dapatkan 1 baris [WaktuBerhentiEntitiData] jika memberikan sama ada [idPerjalanan]
  /// atau [idHentian].
  ///
  /// Jika memberikan kedua-dua parameter, [idPerjalanan] akan diutamakan.
  /// Jika ingin mendapatkan data menggunakan [idPerjalanan],
  /// pastikan untuk memberikan juga nilai kepada [susunanBerhenti] atau nilai
  /// lalai ialah 1.
  Future<WaktuBerhentiEntitiData?> dapatkanMelalui({
    String? idPerjalanan,
    String? idHentian,
    WaktuBerhentiEntitiData? dataWaktuBerhenti,
    int susunanBerhenti = 1,
  }) async {
    final query = select(waktuBerhentiEntiti);

    if (idPerjalanan != null) {
      query.where((wb) =>
          wb.idPerjalanan.equals(idPerjalanan) &
          wb.susunanBerhenti.equals(susunanBerhenti));
    } else if (idHentian != null) {
      query.where((wb) => wb.idHentian.equals(idHentian));
    } else if (dataWaktuBerhenti != null) {
      query.whereSamePrimaryKey(dataWaktuBerhenti);
    } else {
      throw ArgumentError(
          'Perlu sekurang-kurangnya memberikan `idPerjalanan` atau `idHentian`');
    }

    return await query.getSingleOrNull();
  }

  /// dapatakan senarai [WaktuBerhentiEntitiData] yang disusun mengikut susunan
  /// menaik [WaktuBerhentiEntitiData.susunanBerhenti].
  ///
  /// Wajib memberikan [idPerjalanan]. Ubah susunan data kepada menurun menggunakan
  /// [susunMenaikSusunanBerhenti].
  Future<List<WaktuBerhentiEntitiData>?> dapatkanSemuaMelalui({
    required String idPerjalanan,
    bool susunMenaikSusunanBerhenti = true,
  }) async {
    final query = select(waktuBerhentiEntiti);

    query
      ..where((wb) => wb.idPerjalanan.equals(idPerjalanan))
      ..orderBy([
        (wb) => OrderingTerm(
              expression: wb.susunanBerhenti,
              mode: susunMenaikSusunanBerhenti
                  ? OrderingMode.asc
                  : OrderingMode.desc,
            )
      ]);

    return await query.get();
  }
}
