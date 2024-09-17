import 'package:awan/database/dao/entiti/kalendar.dart';
import 'package:awan/database/dao/entiti/laluan_bas.dart';
import 'package:awan/database/dao/entiti/perjalanan.dart';
import 'package:awan/database/dao/entiti/waktu_berhenti.dart';
import 'package:drift/drift.dart';

import '../../util/roggle.dart';
import '../pangkalan_data.dart';

class DaoBerkaitanLaluan extends DatabaseAccessor<PangkalanDataApl> {
  DaoBerkaitanLaluan(super.db);

  /// Berikan [kodLaluan] seperti "T542", "T818" dan akan mendapatkan jadual
  /// ketibaan bas.
  ///
  /// TODO: Masukkan juga [hentian] untuk mendapatkan jadual ketibaan bas pada hentian
  /// tersebut
  Future<List<DateTime>?> jadualKetibaanMengikut({
    required String kodLaluan,
  }) async {
    final laluanBasDao = LaluanBasDao(db);
    final perjalananDao = PerjalananDao(db);
    final waktuBerhentiDao = WaktuBerhentiDao(db);
    final kalendarDao = KalendarDao(db);

    List<DateTime> senaraiWaktuBerhenti = [];

    final laluanData = await laluanBasDao.dapatkanMelalui(
      kodLaluan: kodLaluan,
    );

    if (laluanData == null) {
      rog.i('$kodLaluan tidak ditemui');
      return null;
    }

    final kalendarData = await kalendarDao.dapatkanMengikut(
      tarikh: DateTime.now(),
    );

    final perjalananData = await perjalananDao.dapatkanSemuaMelalui(
      idLaluan: laluanData.idLaluan,
      idPerkhidmatan: kalendarData?.idPerkhidmatan,
    );

    if (perjalananData == null || perjalananData.isEmpty) {
      rog.i('${laluanData.idLaluan} tidak ditemui di dalam table Perjalanan');
      return null;
    }

    for (var p in perjalananData) {
      final masaKetibaan = await waktuBerhentiDao.dapatkanMelalui(
        idPerjalanan: p.idPerjalanan,
      );

      if (masaKetibaan?.ketibaan != null) {
        senaraiWaktuBerhenti.add(masaKetibaan!.ketibaan!);
      }
    }

    return senaraiWaktuBerhenti;
  }
}
