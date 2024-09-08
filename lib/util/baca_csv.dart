import 'package:awan/util/buka_zip.dart';
import 'package:awan/util/extension/string.dart';
import 'package:csv/csv.dart';

import '../model/constant/fail_txt.dart';
import '../model/constant/jenis_perkhidmatan.dart';
import '../model/gtfs/agensi.dart';
import '../model/gtfs/bentuk.dart';
import '../model/gtfs/frekuensi.dart';
import '../model/gtfs/hentian.dart';
import '../model/gtfs/kalendar.dart';
import '../model/gtfs/laluan.dart';
import '../model/gtfs/perjalanan.dart';
import '../model/gtfs/waktu_berhenti.dart';

List<T> bacaCsv<T>(
    {required FailTxt dariTxt, required JenisPerkhidmatan endpoint}) {
  final arkib = bukaZip(endpoint);
  List<T> senaraiObjek = [];

  final input =
      arkib.firstWhere((file) => file.name.endsWith(dariTxt.nama.txt));
  final kandungan = String.fromCharCodes(input.content);

  final baris =
      const CsvToListConverter().convert(kandungan, eol: '\n').sublist(1);

  for (final b in baris) {
    final objek = switch (dariTxt) {
      FailTxt.agensi => Agensi.dariCsv(b, endpoint),
      FailTxt.kalendar => Kalendar.dariCsv(b, endpoint),
      FailTxt.frekuensi => Frekuensi.dariCsv(b, endpoint),
      FailTxt.laluan => Laluan.dariCsv(b, endpoint),
      FailTxt.bentuk => Bentuk.dariCsv(b, endpoint),
      FailTxt.waktuBerhenti => WaktuBerhenti.dariCsv(b, endpoint),
      FailTxt.hentian => Hentian.dariCsv(b, endpoint),
      FailTxt.perjalanan => Perjalanan.dariCsv(b, endpoint),
    };
    senaraiObjek.add(objek as T);
  }

  return senaraiObjek;
}
