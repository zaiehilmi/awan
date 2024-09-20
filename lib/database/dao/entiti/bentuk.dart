import 'package:drift/drift.dart';

import '../../jadual.dart';
import '../../pangkalan_data.dart';

part 'bentuk.g.dart';

@DriftAccessor(tables: [BentukEntiti])
class BentukDao //
    extends DatabaseAccessor<PangkalanDataApl> with _$BentukDaoMixin {
  BentukDao(super.db);

  Future<BentukEntitiData?> dapatkanMelalui({
    required String idBentuk,
    int susunan = 1,
  }) async {
    final query = select(bentukEntiti);

    query
      ..where((b) => b.idBentuk.equals(idBentuk))
      ..where((b) => b.susunan.equals(susunan))
      ..limit(1);

    return await query.getSingleOrNull();
  }

  Future<List<BentukEntitiData>?> dapatkanSemuaMelalui({
    required String idBentuk,
  }) async {
    final query = select(bentukEntiti);

    query.where((b) => b.idBentuk.equals(idBentuk));

    return await query.get();
  }
}
