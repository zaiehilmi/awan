import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LaluanButiranUtama extends HookWidget {
  String kodLaluan = '';

  LaluanButiranUtama({super.key, required this.kodLaluan});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Saya di skrin $kodLaluan'),
    );
  }
}
