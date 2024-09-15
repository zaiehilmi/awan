extension Objek on Object {
  String _keCamelCase(String nama) {
    return nama[0].toLowerCase() + nama.substring(1);
  }

  /// jika kelas anda ialah `KelasSaya`, ia akan menjadi `kelasSaya`
  String get namaKelas {
    String nama = runtimeType.toString();
    return _keCamelCase(nama);
  }

  /// khusus untuk kegunaan router. Jika kelas anda ialah `KelasSaya`, ia akan menjadi
  /// `/kelasSaya`
  String get laluanRouter {
    String nama = runtimeType.toString();
    return '/${_keCamelCase(nama)}';
  }
}
