import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../model/gtfs/index.dart';
import 'dao/entiti/laluan_bas.dart';
import 'dao/entiti/waktu_berhenti.dart';
import 'jadual.dart';

part 'pangkalan_data.g.dart';

@DriftDatabase(tables: [
  AgensiEntiti,
  BentukEntiti,
  FrekuensiEntiti,
  HentianEntiti,
  LaluanEntiti,
  PerjalananEntiti,
  WaktuBerhentiEntiti,
], daos: [
  LaluanBasDao,
  WaktuBerhentiDao,
])
class PangkalanDataApl extends _$PangkalanDataApl {
  PangkalanDataApl() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file, logStatements: true);
  });
}
