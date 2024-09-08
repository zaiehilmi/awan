/// String dalam bahasa Melayu ialah rentetan
extension Rentetan on String {
  String get txt => '$this.txt';

  DateTime get keDateTime {
    final harini = DateTime.now();
    var tarikh = this;

    if (length != 8) tarikh = '0$this';
    String formattedBulan =
        harini.month < 10 ? '0${harini.month}' : harini.month.toString();
    String formattedHari =
        harini.day < 10 ? '0${harini.day}' : harini.day.toString();

    return DateTime.parse(
        '${harini.year}-$formattedBulan-$formattedHari $tarikh');
  }

  String? get jadiNullJikaTiadaData => this != '' ? this : null;

  String get hurufPertamaBesar => this[0].toUpperCase() + substring(1);
}
