import 'dart:io';

import 'package:crypto/crypto.dart';

@Deprecated('tak pakai dalam code')
bool bandingHash(String failDimuatturun, String dariAPi) {
  List<int> local = File(failDimuatturun).readAsBytesSync();
  final localDigest = md5.convert(local).toString();

  return localDigest == dariAPi;
}
