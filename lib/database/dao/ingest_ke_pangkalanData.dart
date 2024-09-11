import 'package:awan/database/pangkalan_data.dart';
import 'package:awan/model/gtfs/index.dart';
import 'package:awan/service/state/vm_lokal.dart';
import 'package:awan/util/roggle.dart';
import 'package:drift/drift.dart';

final _db = lokalState.db;

Future<void> addSemuaAgensiDao(List<Agensi> entri) async {
  await _db.batch((batch) => batch.insertAll(
        _db.agensiEntiti,
        entri.map(
          (e) => AgensiEntitiCompanion.insert(
            idAgensi: Value(e.idAgensi),
            namaAgensi: e.namaAgensi,
            url: e.url,
            zonWaktu: e.zonWaktu,
            noTel: Value(e.noTel),
            bahasa: Value(e.bahasa),
          ),
        ),
      ));

  final semua = await _db.select(_db.agensiEntiti).get();
  rog.i('Saiz Agensi\t${semua.length}');
}

Future<void> addSemuaBentukDao(List<Bentuk> entri) async {
  await _db.batch((batch) => batch.insertAll(
        _db.bentukEntiti,
        entri.map((e) => BentukEntitiCompanion.insert(
              idBentuk: e.idBentuk,
              lat: e.lat,
              lon: e.lon,
              susunan: e.susunan,
            )),
      ));

  final semua = await _db.select(_db.bentukEntiti).get();
  rog.i('Saiz Bentuk\t${semua.length}');
}

/// ada dalam bas kl je
Future<int> addFrekuensiDao(Frekuensi entri) =>
    _db.into(_db.frekuensiEntiti).insert(
          FrekuensiEntitiCompanion.insert(
            idPerjalanan: entri.idPerjalanan,
            masaMula: entri.masaMula,
            masaTamat: entri.masaTamat,
            headwaySecs: entri.headwaySecs,
            exactTimes: Value(entri.exactTimes),
          ),
        );

Future<void> addSemuaHentianDao(List<Hentian> entri) async {
  await _db.batch((batch) => batch.insertAll(
        _db.hentianEntiti,
        entri.map((e) => HentianEntitiCompanion.insert(
              idHentian: e.idHentian,
              huraianHentian: Value(e.huraianHentian),
              lat: Value(e.lat),
              lon: Value(e.lon),
              namaHentian: Value(e.namaHentian),
            )),
      ));

  final semua = await _db.select(_db.hentianEntiti).get();
  rog.i('Saiz Hentian\t${semua.length}');
}

// TODO: kalendar entiti

Future<void> addSemuaLaluanDao(List<Laluan> entri) async {
  await _db.batch((batch) => batch.insertAll(
        _db.laluanEntiti,
        entri.map((e) => LaluanEntitiCompanion.insert(
              idLaluan: e.idLaluan,
              idAgensi: Value(e.idAgensi),
              namaPendek: Value(e.namaPendek),
              namaPenuh: e.namaPenuh,
              jenisKenderaan: e.jenisKenderaan,
              warnaLaluan: Value(e.warnaLaluan),
              warnaTeksLaluan: Value(e.warnaTeksLaluan),
            )),
      ));

  final semua = await _db.select(_db.laluanEntiti).get();
  rog.i('Saiz Laluan\t${semua.length}');
}

Future<void> addSemuaPerjalananDao(List<Perjalanan> entri) async {
  await _db.batch((batch) => batch.insertAll(
        _db.perjalananEntiti,
        entri.map((e) => PerjalananEntitiCompanion.insert(
              idPerjalanan: e.idPerjalanan,
              idLaluan: e.idLaluan,
              idPerkhidmatan: e.idPerkhidmatan,
              idArah: Value(e.idArah),
              idBentuk: Value(e.idBentuk),
              petunjukPerjalanan: Value(e.petunjukPerjalanan),
            )),
      ));

  final semua = await _db.select(_db.perjalananEntiti).get();
  rog.i('Saiz Perjalanan\t${semua.length}');
}

Future<void> addSemuaWaktuBerhentiDao(List<WaktuBerhenti> entri) async {
  await _db.batch((batch) => batch.insertAll(
        _db.waktuBerhentiEntiti,
        entri.map((e) => WaktuBerhentiEntitiCompanion.insert(
              idPerjalanan: e.idPerjalanan,
              ketibaan: Value(e.ketibaan),
              pelepasan: Value(e.pelepasan),
              idHentian: e.idHentian,
              susunanBerhenti: e.susunanBerhenti,
              petunjuk: Value(e.petunjuk),
            )),
      ));

  final semua = await _db.select(_db.waktuBerhentiEntiti).get();
  rog.i('Saiz Waktu berhenti\t${semua.length}');
}
