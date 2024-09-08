// Singleton dengan muat-bila-perlu

import 'package:awan/model/gtfs/perjalanan.dart';
import 'package:awan/model/gtfs/waktu_berhenti.dart';

import '../../util/baca_csv.dart';
import '../constant/fail_txt.dart';
import '../constant/jenis_perkhidmatan.dart';
import 'hentian.dart';
import 'laluan.dart';

/// Gabungan semua maklumat dari bas KL dan bas perantara MRT
class SemuaData {
  static SemuaData? _semuaData;

  SemuaData._();

  static SemuaData get instance => _semuaData ??= SemuaData._();

  List<Hentian> get semuaHentian =>
      _semuaDataDaripadaJadual(failTxt: FailTxt.hentian);

  List<WaktuBerhenti> get semuaWaktuBerhenti =>
      _semuaDataDaripadaJadual(failTxt: FailTxt.waktuBerhenti);

  List<Laluan> get semuaLaluan =>
      _semuaDataDaripadaJadual(failTxt: FailTxt.laluan);

  List<Perjalanan> get semuaPerjalanan =>
      _semuaDataDaripadaJadual(failTxt: FailTxt.perjalanan);

  List<J> _semuaDataDaripadaJadual<J>({required FailTxt failTxt}) {
    // final basKL = bacaCsv<J>(dariTxt: failTxt, endpoint: JenisPerkhidmatan.basKL);
    final basMRT = bacaCsv<J>(
        dariTxt: failTxt, endpoint: JenisPerkhidmatan.basPerantaraMrt);

    // basMRT.addAll(basKL);

    // buang data sama
    basMRT.toSet().toList();

    // susun mengikut aturan semakin menaik
    // basMRT.toSet().toList().sort((a, b) => lajurA?.compareTo(lajurB));
    // basMRT.toSet().toList().sort((a, b) => a.idHentian.compareTo(b.idHentian));
    return basMRT;
  }
}

final SemuaData dataBas = SemuaData.instance;
