extension Durasi on Duration {
  /// untuk mendapatkan perbezaan masa dalam format yang lebih mesra dibaca.
  String get mesra {
    if (inMinutes < 1) {
      return 'kurang dari seminit';
    } else if (inMinutes == 1) {
      return '1 minit lagi';
    } else if (inMinutes < 60) {
      return '${inMinutes} minit lagi';
    } else if (inHours == 1) {
      return '1 jam lagi';
    } else {
      return '${inHours} jam lagi';
    }
  }
}
