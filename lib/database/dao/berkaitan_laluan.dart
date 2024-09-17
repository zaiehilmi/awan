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

    senaraiWaktuBerhenti.sort((a, b) => a.compareTo(b));

    return senaraiWaktuBerhenti;
  }

  /// Semua laluan bas
  Future<Map<String, String>> semuaLaluan() async {
    final laluanDao = LaluanBasDao(db);
    final perjalananDao = PerjalananDao(db);

    List<MapEntry<String, String>> entriLaluan = [];

    final senaraiLaluan = await laluanDao.dapatkanSemua();
    for (var l in senaraiLaluan) {
      final p = await perjalananDao.dapatkanSemuaMelalui(idLaluan: l.idLaluan);

      final namaPetunjuk = p!.isNotEmpty
          ? p.first.petunjukPerjalanan ?? l.namaPenuh
          : l.namaPenuh;

      entriLaluan.add(MapEntry(l.namaPenuh, namaPetunjuk));
    }

    entriLaluan.sort((a, b) => a.key.compareTo(b.key));
    final memetakan = Map.fromEntries(entriLaluan);

    rog.d('Saiz semua laluan: ${memetakan.length}');
    return memetakan;
  }
}
