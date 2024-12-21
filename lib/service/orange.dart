import 'package:orange/orange.dart';

import '../util/roggle.dart';

enum JenisDataOren { string, int, double, boolean, list, map }

enum KunciOren {
  etagRapidKL(JenisDataOren.string),
  etagPerantaraMRT(JenisDataOren.string),
  penanda(JenisDataOren.list);

  final JenisDataOren jenisData;

  const KunciOren(this.jenisData);
}

/// Oren atau nama sebenarnya `Orange` merupakan alternatif kepada
/// `shared_preferences` yang digunakan untuk menyimpan maklumat mudah ke dalam
/// storan lokal.
class Oren {
  Oren._privateConstructor();
  static final Oren _instance = Oren._privateConstructor();

  factory Oren() {
    return _instance;
  }

  void set(KunciOren kunci, dynamic data) {
    switch (kunci.jenisData) {
      case JenisDataOren.string:
        data is String
            ? Orange.setString(kunci.name, data)
            : throw Exception(
                "Jenis data tidak sepadan dengan String untuk kunci ${kunci.name}");
        break;

      case JenisDataOren.int:
        data is int
            ? Orange.setInt(kunci.name, data)
            : throw Exception(
                "Jenis data tidak sepadan dengan int untuk kunci ${kunci.name}");
        break;

      case JenisDataOren.double:
        data is double
            ? Orange.setDouble(kunci.name, data)
            : throw Exception(
                "Jenis data tidak sepadan dengan double untuk kunci ${kunci.name}");
        break;

      case JenisDataOren.boolean:
        data is bool
            ? Orange.setBool(kunci.name, data)
            : throw Exception(
                "Jenis data tidak sepadan dengan boolean untuk kunci ${kunci.name}");
        break;

      case JenisDataOren.list:
        data is List
            ? Orange.setList(kunci.name, data)
            : throw Exception(
                "Jenis data tidak sepadan dengan List untuk kunci ${kunci.name}");
        break;

      case JenisDataOren.map:
        throw Exception(
            "Jenis data `Map` belum disokong untuk kunci ${kunci.name}");
      // data is Map
      //     ? Orange.setMap(kunci.name, data)
      //     : throw Exception("Jenis data tidak sepadan dengan Map untuk kunci ${kunci.name}");
      // break;

      default:
        throw Exception("Jenis data tidak disokong untuk kunci ${kunci.name}");
    }

    rog.d("Menyimpan ${data.toString()} sebagai ${kunci.jenisData}");
  }

  /// Fungsi `get` untuk mengambil data berdasarkan `KunciOren` dengan generik
  T get<T>(KunciOren kunci) {
    return switch (kunci.jenisData) {
      JenisDataOren.string => Orange.getString(kunci.name) as T,
      JenisDataOren.int => Orange.getInt(kunci.name) as T,
      JenisDataOren.double => Orange.getDouble(kunci.name) as T,
      JenisDataOren.boolean => Orange.getBool(kunci.name) as T,
      JenisDataOren.list => Orange.getList(kunci.name) as T,
      JenisDataOren.map ||
      _ =>
        throw Exception("Jenis data tidak disokong untuk kunci ${kunci.name}")
    };
  }
}
