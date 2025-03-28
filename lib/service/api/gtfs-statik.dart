import 'dart:io';

import 'package:dio/dio.dart';

import '../../database/dao/ingest_ke_pangkalanData.dart';
import '../../database/dao/zon_bahaya.dart';
import '../../model/constant/fail_txt.dart';
import '../../model/constant/jenis_perkhidmatan.dart';
import '../../model/gtfs/index.dart';
import '../../util/baca_csv.dart';
import '../../util/roggle.dart';
import '../orange.dart';
import '../state/vm_bas.dart';
import '../state/vm_lokal.dart';
import '../tetapan.dart';

final _options = BaseOptions(
  method: 'get',
  baseUrl: 'https://api.data.gov.my/gtfs-static/prasarana',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 5),
);

final dio = Dio(_options);

Future<void> apiGtfsStatik(
  JenisPerkhidmatan perkhidmatan, {
  bool semakPerubahan = true,
}) async {
  final kedudukanFail = (Tetapan.filePath == null)
      ? 'out/${perkhidmatan.nama}.zip'
      : '${Tetapan.filePath}/out/${perkhidmatan.nama}.zip';
  final laluanApi = '?category=${perkhidmatan.nama}';
  bool muatTurunBerjaya = false;

  lokalState.memuatkanDb(kemajuan: 0.1);

  try {
    if (Tetapan.token != null) {
      _options.headers = {'Authorization': 'Bearer ${Tetapan.token}'};
    }

    final response = await dio.head(laluanApi);
    final etagBaru = response.headers.value('etag').toString();
    final kemaskiniTersedia =
        Oren().get(KunciOren.etagPerantaraMRT) != etagBaru;

    rog.d(response.requestOptions.uri);

    lokalState.memuatkanDb(kemajuan: 0.2);

    if (semakPerubahan && kemaskiniTersedia) {
      rog.i('Terdapat perubahan pada fail, memuat turun versi baru...');

      await dio.download(laluanApi, kedudukanFail);
      await _bilaKemaskiniTersedia(etag: etagBaru);

      muatTurunBerjaya = true;
    } else if (kemaskiniTersedia == false) {
      rog.i('Tiada perubahan, fail tidak perlu dimuat turun');
    } else {
      rog.i('Fail cache telah wujud, tiada muat turun diperlukan.');
    }

    rog.i('Selesai memuat API');
    lokalState.memuatkanDb(kemajuan: 1);
  } on DioException {
    rog.e('Masalah di Dio');
  } catch (e) {
    rog.t('Ralat kritikal', error: e);
  } finally {
    dio.close();

    if (muatTurunBerjaya) {
      await _buangFailCache(kedudukanFail);
    }
  }
}

Future<void> _muatTurunBaharu({required String etag}) async {
  Oren().set(KunciOren.etagPerantaraMRT, etag);
  lokalState.memuatkanDb(kemajuan: 0.3);

  await _prosesData<Agensi>(FailTxt.agensi, addSemuaAgensiDao);
  await _prosesData<Bentuk>(FailTxt.bentuk, addSemuaBentukDao);

  lokalState.memuatkanDb(kemajuan: 0.35);

  await _prosesData<Hentian>(FailTxt.hentian, addSemuaHentianDao);
  await _prosesData<Kalendar>(FailTxt.kalendar, addSemuaKalendarDao);

  lokalState.memuatkanDb(kemajuan: 0.4);

  await _prosesData<Laluan>(FailTxt.laluan, addSemuaLaluanDao);
  await _prosesData<Perjalanan>(FailTxt.perjalanan, addSemuaPerjalananDao);

  lokalState.memuatkanDb(kemajuan: 0.45);

  await _prosesData<WaktuBerhenti>(
    FailTxt.waktuBerhenti,
    addSemuaWaktuBerhentiDao,
  );

  lokalState.memuatkanDb(kemajuan: 0.9);
}

Future<void> _prosesData<T>(
  FailTxt failTxt,
  Future<void> Function(List<T>) insertFunction,
) async {
  final dataList = bacaCsv<T>(
    dariTxt: failTxt,
    endpoint: JenisPerkhidmatan.basPerantaraMrt,
  );

  await insertFunction(dataList);
}

Future<void> _bilaKemaskiniTersedia({required String etag}) async {
  Oren().set(KunciOren.etagPerantaraMRT, etag);

  basState.senaraiLaluan = [];
  basState.setState();

  ZonBahayaDao(lokalState.db).kosongkanSemua();

  await _muatTurunBaharu(etag: etag);
}

Future<void> _buangFailCache(String filePath) async {
  final file = File(filePath);

  if (await file.exists()) {
    try {
      await file.delete();
      rog.i('Fail dihapuskan: $filePath');
    } catch (e) {
      rog.e('Gagal untuk memadam fail: $e');
    }
  } else {
    rog.e('Fail tidak wujud: $filePath');
  }
}
