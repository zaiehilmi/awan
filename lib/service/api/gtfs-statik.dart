import 'dart:io';

import 'package:awan/database/dao/ingest_ke_pangkalanData.dart';
import 'package:awan/model/constant/fail_txt.dart';
import 'package:awan/service/state/vm_bas.dart';
import 'package:awan/util/baca_csv.dart';
import 'package:awan/util/roggle.dart';
import 'package:dio/dio.dart';
import 'package:orange/orange.dart';

import '../../model/constant/jenis_perkhidmatan.dart';
import '../../model/gtfs/index.dart';
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

  try {
    if (Tetapan.token != null) {
      _options.headers = {'Authorization': 'Bearer ${Tetapan.token}'};
    }

    final response = await dio.head(laluanApi);
    final etagBaru = response.headers.value('etag').toString();
    final kemaskiniTersedia = Orange.getString('etag') != etagBaru;
    final failBelumWujud = !File(kedudukanFail).existsSync();
    rog.d(response.requestOptions.uri);

    if (failBelumWujud) {
      // Fail belum wujud, terus muat turun
      rog.i('Memuat turun fail dari ${response.requestOptions.path}');

      await dio.download(laluanApi, kedudukanFail);
      await _muatTurunBaharu(etag: etagBaru);
    } else if (semakPerubahan && kemaskiniTersedia) {
      rog.i('Terdapat perubahan pada fail, memuat turun versi baru...');

      _bilaKemaskiniTersedia(etag: etagBaru);
      await dio.download(laluanApi, kedudukanFail);
    } else if (kemaskiniTersedia == false) {
      rog.i('Tiada perubahan, fail tidak perlu dimuat turun');
    } else {
      rog.i('Fail cache telah wujud, tiada muat turun diperlukan.');
    }

    rog.i('Selesai memuat API');
  } on DioException {
    rog.e('Masalah di Dio');
  } catch (e) {
    rog.t('Ralat kritikal', error: e);
  } finally {
    dio.close();
  }
}

Future<void> _muatTurunBaharu({required String etag}) async {
  Orange.setString('etag', etag);

  await _prosesData<Agensi>(FailTxt.agensi, addSemuaAgensiDao);
  await _prosesData<Bentuk>(FailTxt.bentuk, addSemuaBentukDao);
  await _prosesData<Hentian>(FailTxt.hentian, addSemuaHentianDao);
  await _prosesData<Kalendar>(FailTxt.kalendar, addSemuaKalendarDao);
  await _prosesData<Laluan>(FailTxt.laluan, addSemuaLaluanDao);
  await _prosesData<Perjalanan>(FailTxt.perjalanan, addSemuaPerjalananDao);
  await _prosesData<WaktuBerhenti>(
    FailTxt.waktuBerhenti,
    addSemuaWaktuBerhentiDao,
  );
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
  Orange.setString('etag', etag);

  // delete table
}
