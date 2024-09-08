import 'package:collection/collection.dart';

import '../../model/gtfs/index.dart';
import '../../model/gtfs/semua_data.dart';
import '../../util/roggle.dart';

Future<List<Laluan>> getSemuaLaluan() async {
  final dataLaluan = dataBas.semuaLaluan;

  dataLaluan.forEachIndexed((i, laluan) => rog.d('$i ${laluan.toString()}'));

  return dataLaluan;
}

/// mendapatkan jadual bas. Berikan [bas] dengan kod laluan seperti `T542`, `T852`
@Deprecated('Akan gunakan database pula lpsni')
Future<List<DateTime>> jadualKetibaan({required String bas}) async {
  // Cari laluan berdasarkan kod laluan
  final turasKodLaluan = _cariLaluan(bas);
  if (turasKodLaluan == null) return [];

  // Dapatkan senarai masa ketibaan
  final listWaktuBerhenti = _dapatkanMasaKetibaan(turasKodLaluan.idLaluan);

  // Map untuk mendapatkan ketibaan, tapis null, dan sort
  final jadual = listWaktuBerhenti
      .map((e) => e.ketibaan)
      .whereType<DateTime>() // Hanya benarkan DateTime, tapis null
      .toSet()
      .toList()
    ..sort((a, b) => a.compareTo(b)); // Sort dalam urutan menaik

  rog.i('Saiz ketibaan bas $bas: ${jadual.length}');

  return jadual;
}

// MARK: UTILITI

/// Fungsi untuk mencari laluan berdasarkan kod laluan
Laluan? _cariLaluan(String kodLaluan) {
  final dataLaluan = dataBas.semuaLaluan;

  return dataLaluan.singleWhereIndexedOrNull(
    (index, l) => l.namaPenuh == kodLaluan,
  );
}

/// Fungsi untuk mendapatkan masa ketibaan
List<WaktuBerhenti> _dapatkanMasaKetibaan(String idLaluan) {
  final dataPerjalanan = dataBas.semuaPerjalanan;
  final dataWaktuBerhenti = dataBas.semuaWaktuBerhenti;
  List<WaktuBerhenti> wb = [];

  final turasPerjalanan = dataPerjalanan.where(
    (p) => p.idLaluan == idLaluan,
  );

  for (var perjalanan in turasPerjalanan) {
    var masaBerlepas = dataWaktuBerhenti.firstWhere(
      (wbItem) => wbItem.idPerjalanan == perjalanan.idPerjalanan,
    );
    wb.add(masaBerlepas);
  }

  return wb.toSet().toList(); // Hapuskan pendua
}

/// Fungsi untuk membandingkan waktu ketibaan
int _bandingkanKetibaan(DateTime? a, DateTime? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}
