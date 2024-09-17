import 'package:awan/util/extension/dateTime.dart';
import 'package:drift/drift.dart';

import '../../jadual.dart';
import '../../pangkalan_data.dart';

part 'kalendar.g.dart';

@DriftAccessor(tables: [KalendarEntiti])
class KalendarDao //
    extends DatabaseAccessor<PangkalanDataApl> with _$KalendarDaoMixin {
  KalendarDao(super.db);

  Future<KalendarEntitiData?> dapatkanMengikut({
    required DateTime tarikh,
  }) async {
    final query = select(kalendarEntiti);

    query
      ..where((k) => k.tarikhMula.isSmallerOrEqualValue(tarikh.tarikhTanpaMasa))
      ..where((k) => k.tarikhTamat.isBiggerOrEqualValue(tarikh.tarikhTanpaMasa))
      ..limit(1);

    return await query.getSingleOrNull();
  }
}
