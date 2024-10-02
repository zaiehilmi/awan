import 'package:awan/util/roggle.dart';
import 'package:drift/drift.dart';

import '../pangkalan_data.dart';

/// Mengumpulkan query yang berbahaya sahaja
class ZonBahayaDao extends DatabaseAccessor<PangkalanDataApl> {
  ZonBahayaDao(super.db);

  /// buang semua data dan gantikan dengan data yang baru dari API
  Future<void> kosongkanSemua() async {
    rog.i('Mengosongkan data dari pangkalan data');

    await delete(db.agensiEntiti).go();
    await delete(db.bentukEntiti).go();
    await delete(db.frekuensiEntiti).go();
    await delete(db.hentianEntiti).go();
    await delete(db.kalendarEntiti).go();
    await delete(db.laluanEntiti).go();
    await delete(db.perjalananEntiti).go();
    await delete(db.waktuBerhentiEntiti).go();
  }
}
