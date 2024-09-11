bool isTimeAfter(DateTime time1, DateTime time2) {
  final time1Only = DateTime(2000, 1, 1, time1.hour, time1.minute, time1.second);
  final time2Only = DateTime(2000, 1, 1, time2.hour, time2.minute, time2.second);

  return time1Only.isAfter(time2Only);
}
