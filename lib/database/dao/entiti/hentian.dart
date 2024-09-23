import 'package:drift/drift.dart';

import '../../jadual.dart';
import '../../pangkalan_data.dart';

part 'hentian.g.dart';

@DriftAccessor(tables: [HentianEntiti])
class HentianDao //
    extends DatabaseAccessor<PangkalanDataApl> with _$HentianDaoMixin {
  HentianDao(super.db);

  Future<List<HentianEntitiData>> dapatkanSemua() async {
    final query = select(hentianEntiti);

    return await query.get();
  }
}
