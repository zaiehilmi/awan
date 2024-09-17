import 'package:drift/drift.dart';

import '../../jadual.dart';
import '../../pangkalan_data.dart';

part 'laluan_bas.g.dart';

@DriftAccessor(tables: [
  LaluanEntiti,
  WaktuBerhentiEntiti,
  PerjalananEntiti,
])
class LaluanBasDao //
    extends DatabaseAccessor<PangkalanDataApl> with _$LaluanBasDaoMixin {
  LaluanBasDao(super.db);

  /// dapatkan 1 baris [LaluanEntitiData].
  ///
  /// berikan sama ada (semakin ke atas, semakin diutamakan):
  /// - [kodLaluan] seperti `"T542"`
  /// - [idLaluan]
  /// - [dataLaluan]
  Future<LaluanEntitiData?> dapatkanMelalui({
    String? kodLaluan,
    String? idLaluan,
    LaluanEntitiData? dataLaluan,
  }) async {
    final query = select(laluanEntiti);

    if (kodLaluan != null) {
      // lakukan carian hanya dengan upper case
      query.where((l) => l.namaPenuh.equals(kodLaluan.toUpperCase()));
    } else if (idLaluan != null) {
      query.where((l) => l.idLaluan.equals(idLaluan));
    } else if (dataLaluan != null) {
      query.whereSamePrimaryKey(dataLaluan);
    } else {
      throw ArgumentError(
          'Perlu sekurang-kurangnya memberikan `kodLaluan`, `idLaluan`, atau `dataLaluan`');
    }

    query.limit(1);

    return await query.getSingleOrNull();
  }

  /// dapatkan senarai penuh [LaluanEntitiData] tanpa sebarang syarat
  Future<List<LaluanEntitiData>> dapatkanSemua() async =>
      await select(laluanEntiti).get();
}
