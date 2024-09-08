import 'package:drift/drift.dart';

import '../model/gtfs/index.dart';

class AgensiEntiti extends Table {
  TextColumn get idAgensi => text().unique()();
  TextColumn get namaAgensi => text()();
  TextColumn get url => text()();
  TextColumn get zonWaktu => text()();
  TextColumn get noTel => text().nullable()();
  TextColumn get bahasa => text().nullable()();
}

class BentukEntiti extends Table {
  TextColumn get idBentuk => text().unique()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  IntColumn get susunan => integer()();
}

class FrekuensiEntiti extends Table {
  TextColumn get idPerjalanan => text().unique()();
  DateTimeColumn get masaMula => dateTime()();
  DateTimeColumn get masaTamat => dateTime()();
  IntColumn get headwaySecs => integer()();
  IntColumn get exactTimes => intEnum<TepatMasa>()();
}

class HentianEntiti extends Table {
  TextColumn get idHentian => text().unique()();
  TextColumn get namaHentian => text().nullable()();
  TextColumn get huraianHentian => text().nullable()();
  RealColumn get lat => real().nullable()();
  RealColumn get lon => real().nullable()();
}

class LaluanEntiti extends Table {
  TextColumn get idLaluan => text().unique()();
  TextColumn get idAgensi =>
      text().nullable().references(AgensiEntiti, #idAgensi)();
  TextColumn get namaPendek => text().nullable()();
  TextColumn get namaPenuh => text()();
  IntColumn get jenisKenderaan => intEnum<JenisKenderaan>()();
  TextColumn get warnaLaluan => text().nullable()();
  TextColumn get warnaTeksLaluan => text().nullable()();
}

class PerjalananEntiti extends Table {
  TextColumn get idPerjalanan => text().unique()();
  TextColumn get idLaluan => text().references(LaluanEntiti, #idLaluan)();
  TextColumn get idPerkhidmatan => text()();
  TextColumn get idBentuk =>
      text().nullable().references(BentukEntiti, #idBentuk)();
  TextColumn get petunjukPerjalanan => text().nullable()();
  IntColumn get arah => intEnum<ArahPerjalanan>().nullable()();
}

class WaktuBerhentiEntiti extends Table {
  IntColumn get id => integer().autoIncrement().unique()();
  TextColumn get idPerjalanan =>
      text().references(PerjalananEntiti, #idPerjalanan)();
  DateTimeColumn get ketibaan => dateTime()();
  DateTimeColumn get pelepasan => dateTime()();
  TextColumn get idHentian => text().references(HentianEntiti, #idHentian)();
  IntColumn get susunanBerhenti => integer()();
  TextColumn get petunjuk => text().nullable()();
}
