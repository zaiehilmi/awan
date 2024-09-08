import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../model/gtfs/index.dart';
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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'my_database');
  }
}
