extension Durasi on Duration {
  /// untuk mendapatkan perbezaan masa dalam format yang lebih mesra dibaca.
  String get mesra {
    if (this.inMinutes < 1) {
      return 'kurang dari seminit';
    } else if (this.inMinutes == 1) {
      return '1 minit lagi';
    } else if (this.inMinutes < 60) {
      return '${this.inMinutes} minit lagi';
    } else if (this.inHours == 1) {
      return '1 jam lagi';
    } else {
      return '${this.inHours} jam lagi';
    }
  }
}
