import 'package:drift/drift.dart';

import '../model/gtfs/index.dart';

class AgensiEntiti extends Table {
  TextColumn get idAgensi => text().nullable()(); //
  TextColumn get namaAgensi => text()(); //
  TextColumn get url => text()(); //
  TextColumn get zonWaktu => text()(); //
  TextColumn get noTel => text().nullable()(); //
  TextColumn get bahasa => text().nullable()();
}

class BentukEntiti extends Table {
  TextColumn get idBentuk => text()(); //
  RealColumn get lat => real()(); //
  RealColumn get lon => real()(); //
  IntColumn get susunan => integer()(); //

  @override
  Set<Column> get primaryKey => {idBentuk, susunan};
}

class FrekuensiEntiti extends Table {
  TextColumn get idPerjalanan => text()(); //
  DateTimeColumn get masaMula => dateTime()(); //
  DateTimeColumn get masaTamat => dateTime()(); //
  IntColumn get headwaySecs => integer()(); //
  IntColumn get exactTimes => intEnum<TepatMasa>().nullable()(); //

  @override
  Set<Column> get primaryKey => {idPerjalanan};
}

class HentianEntiti extends Table {
  TextColumn get idHentian => text()(); //
  TextColumn get namaHentian => text().nullable()(); //
  TextColumn get huraianHentian => text().nullable()(); //
  RealColumn get lat => real().nullable()(); //
  RealColumn get lon => real().nullable()(); //

  @override
  Set<Column> get primaryKey => {idHentian};
}

class KalendarEntiti extends Table {
  TextColumn get idPerkhidmatan => text()(); //
  IntColumn get isnin => intEnum<Ketersediaan>()(); //
  IntColumn get selasa => intEnum<Ketersediaan>()(); //
  IntColumn get rabu => intEnum<Ketersediaan>()(); //
  IntColumn get khamis => intEnum<Ketersediaan>()(); //
  IntColumn get jumaat => intEnum<Ketersediaan>()(); //
  IntColumn get sabtu => intEnum<Ketersediaan>()(); //
  IntColumn get ahad => intEnum<Ketersediaan>()(); //
  DateTimeColumn get tarikhMula => dateTime()(); //
  DateTimeColumn get tarikhTamat => dateTime()(); //

  @override
  Set<Column> get primaryKey => {idPerkhidmatan};
}

@TableIndex(name: 'kod_laluan', columns: {#namaPenuh})
class LaluanEntiti extends Table {
  TextColumn get idLaluan => text()(); //
  TextColumn get idAgensi => text().nullable()(); //
  TextColumn get namaPendek => text().nullable()(); //
  TextColumn get namaPenuh => text()(); //
  IntColumn get jenisKenderaan => intEnum<JenisKenderaan>()(); //
  TextColumn get warnaLaluan => text().nullable()(); //
  TextColumn get warnaTeksLaluan => text().nullable()(); //

  @override
  Set<Column> get primaryKey => {idLaluan};
}

class PerjalananEntiti extends Table {
  TextColumn get idPerjalanan => text()(); //
  TextColumn get idLaluan => text().references(LaluanEntiti, #idLaluan)(); //
  TextColumn get idPerkhidmatan => text()(); //
  TextColumn get idBentuk => text()
      .nullable() //
      .references(BentukEntiti, #idBentuk)(); //
  TextColumn get petunjukPerjalanan => text().nullable()(); //
  IntColumn get idArah => intEnum<ArahPerjalanan>().nullable()(); //

  @override
  Set<Column> get primaryKey => {idPerjalanan, idPerkhidmatan};
}

class WaktuBerhentiEntiti extends Table {
  TextColumn get idPerjalanan => text() //
      .references(PerjalananEntiti, #idPerjalanan)(); //
  DateTimeColumn get ketibaan => dateTime().nullable()(); //
  DateTimeColumn get pelepasan => dateTime().nullable()(); //
  TextColumn get idHentian => text().references(HentianEntiti, #idHentian)(); //
  IntColumn get susunanBerhenti => integer()(); //
  TextColumn get petunjuk => text().nullable()(); //

  @override
  Set<Column> get primaryKey => {idPerjalanan, susunanBerhenti};
}
