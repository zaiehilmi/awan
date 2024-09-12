import 'package:drift/drift.dart';

import '../../util/roggle.dart';
import '../jadual.dart';
import '../pangkalan_data.dart';

part 'laluan_bas.g.dart';

@DriftAccessor(tables: [
  LaluanEntiti,
  WaktuBerhentiEntiti,
  PerjalananEntiti
])
class LaluanBasDao extends DatabaseAccessor<PangkalanDataApl> with _$LaluanBasDaoMixin {
  LaluanBasDao(super.db);

  /// dapatkan semua laluan bas perantara MRT
  Future<Map<String, String>> semuaLaluan() async {
    List<MapEntry<String, String>> entriLaluan = [];
    final senaraiLaluan = await select(db.laluanEntiti).get();

    for (var laluan in senaraiLaluan) {
      final senaraiPerjalanan = await (
          select(perjalananEntiti)
            ..where((p) => p.idLaluan.equals(laluan.idLaluan))
      ).get();

      final namaPetunjuk = senaraiPerjalanan.isNotEmpty
          ? senaraiPerjalanan.first.petunjukPerjalanan ?? laluan.namaPenuh
          : laluan.namaPenuh;

      entriLaluan.add(MapEntry(laluan.namaPenuh, namaPetunjuk));
    }

    entriLaluan.sort((a, b) => a.key.compareTo(b.key));

    final memetakan = Map.fromEntries(entriLaluan);

    rog.d('Saiz semua laluan: ${memetakan.length}');
    return memetakan;
  }

  /// cara baca: jadual ketibaan mengikut kod laluan
  Future<List<DateTime>> jadualKetibaanMengikut({required String kodLaluan}) async {
    final laluan = await _cariLaluan(kodLaluan);
    if (laluan == null) {
      rog.i('$kodLaluan tidak ditemui');
      return [];
    }

    rog.d('$kodLaluan ditemui -> Laluan.idLaluan: ${laluan.idLaluan}');

    final senaraiWaktuBerhenti = await _dapatkanMasaKetibaan(laluan.idLaluan);

    // Urus nilai null dan pendua, kemudian susun menaik
    final jadual = senaraiWaktuBerhenti
        .map((e) => e.ketibaan)
        .whereType<DateTime>()
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    rog.d('saiz jadual $kodLaluan: ${jadual.length}');
    return jadual;
  }

  // MARK:- 🍄 Utiliti

  /// Cari laluan berdasarkan kod laluan (dalam huruf kecil)
  Future<LaluanEntitiData?> _cariLaluan(String kodLaluan) async {
    return await (
        select(laluanEntiti)
          ..where((t) => t.namaPenuh.lower().equals(kodLaluan.toLowerCase()))
          ..limit(1)
    ).getSingleOrNull();
  }

  /// Cari perjalanan berdasarkan id laluan
  Future<List<WaktuBerhentiEntitiData>> _dapatkanMasaKetibaan(String idLaluan) async {
    List<WaktuBerhentiEntitiData> senaraiWaktuBerhenti = [];

    final senaraiPerjalanan = await (
      select(perjalananEntiti)
        ..where((p) => p.idLaluan.equals(idLaluan))
    ).get();

    for (var p in senaraiPerjalanan) {
      final masaKetibaan = await (
        select(waktuBerhentiEntiti)
          ..where((wb) => wb.idPerjalanan.equals(p.idPerjalanan))
      ).get();

      senaraiWaktuBerhenti.add(masaKetibaan[0]);  // index 0 bermaksud tmpt mula bergerak
    }

    return senaraiWaktuBerhenti.toSet().toList();
  }

  /// Dapatkan waktu berhenti berdasarkan id perjalanan
  Future<List<WaktuBerhentiEntitiData>> _dapatkanWaktuBerhenti(String idPerjalanan) async {
    return await (
        select(db.waktuBerhentiEntiti)
          ..where((t) => t.idPerjalanan.equals(idPerjalanan))
    ).get();
  }
}
