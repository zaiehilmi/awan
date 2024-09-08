import 'dart:io';

import 'package:awan/util/roggle.dart';
import 'package:dio/dio.dart';

import '../../model/constant/jenis_perkhidmatan.dart';
import '../../util/banding_hash.dart';
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

    // dapatkan head response untuk mendapatkan etag yang digunakan untuk
    // menentukan sama ada perlu download fail zip baru atau tidak.
    final response = await dio.head(laluanApi);
    final etag = response.headers.value('etag').toString();

    final failBelumWujud = !File(kedudukanFail).existsSync();
    rog.d(response.requestOptions.uri);

    if (failBelumWujud) {
      rog.i('Memuat turun data... dari ${response.requestOptions.path}');
      await dio.download(laluanApi, kedudukanFail);
    } else {
      if (semakPerubahan && bandingHash(kedudukanFail, etag)) {
        rog.i('Terdapat perubahan pada pelayan. Memuat turun data baru...');
        await dio.download(laluanApi, kedudukanFail);
      }
    }

    rog.i('Selesai memuat API');
  } on DioException {
    rog.e('Masalah di Dio');
  } catch (e) {
    rog.f('Ralat kritikal', error: e);
  } finally {
    dio.close();
  }
}
