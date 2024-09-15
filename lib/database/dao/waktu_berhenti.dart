import 'package:awan/database/pangkalan_data.dart';
import 'package:drift/drift.dart';

import '../jadual.dart';

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
  /// pastikan untuk memberikan juga nilai kepada [susunanBerhenti] atau nilai lalai ialah 1
  Future<WaktuBerhentiEntitiData?> dapatkanMelalui({
    String? idPerjalanan,
    String? idHentian,
    int susunanBerhenti = 1,
  }) async {
    final query = select(waktuBerhentiEntiti);

    if (idPerjalanan != null) {
      query
        ..where((wb) => wb.idPerjalanan.equals(idPerjalanan))
        ..where((wb) => wb.susunanBerhenti.equals(susunanBerhenti));
    } else if (idHentian != null) {
      query //
          .where((wb) => wb.idHentian.equals(idHentian));
    } else {
      throw ArgumentError(
          'Perlu sekurang-kurangnya memberikan `idPerjalanan` atau `idHentian`');
    }

    return await query.getSingleOrNull();
  }

  /// dapatakan senarai
  Future<List<WaktuBerhentiEntitiData>?> dapatkanSemuaMelalui({
    String? idPerjalanan,
    bool susunMenaikSusunanBerhenti = true,
  }) async {
    final query = select(waktuBerhentiEntiti);

    if (idPerjalanan != null) {
      query.where((wb) => wb.idPerjalanan.equals(idPerjalanan));
    } else {
      throw ArgumentError('Kenapa kosong je `idPerjalanan` tu!!');
    }

    query.orderBy([
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
