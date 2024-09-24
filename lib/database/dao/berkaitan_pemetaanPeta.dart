import 'package:awan/database/dao/entiti/bentuk.dart';
import 'package:awan/database/dao/entiti/hentian.dart';
import 'package:awan/database/dao/entiti/laluan_bas.dart';
import 'package:awan/database/pangkalan_data.dart';
import 'package:drift/drift.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../util/roggle.dart';
import 'entiti/perjalanan.dart';

class DaoBerkaitanPemetaanPeta extends DatabaseAccessor<PangkalanDataApl> {
  DaoBerkaitanPemetaanPeta(super.db);

  Future<List<Position>?> lukisLaluanBerdasarkan({
    required String kodLaluan,
  }) async {
    final laluanBasDao = LaluanBasDao(db);
    final perjalananDao = PerjalananDao(db);
    final bentukDao = BentukDao(db);

    List<Position> senaraiLatLng = [];

    final laluanData = await laluanBasDao.dapatkanMelalui(
      kodLaluan: kodLaluan,
    );

    if (laluanData == null) {
      rog.i('$kodLaluan tidak ditemui');
      return null;
    }

    final perjalananData = await perjalananDao.dapatkanSemuaMelalui(
      idLaluan: laluanData.idLaluan,
    );
    rog.d('saiz perjalanan --> ${perjalananData?.length}');

    if (perjalananData == null || perjalananData.isEmpty) {
      rog.i('${laluanData.idLaluan} tidak ditemui di dalam table Perjalanan');
      return null;
    }

    final bentukPerjalanan = await bentukDao.dapatkanSemuaMelalui(
      idBentuk: perjalananData[0].idBentuk!,
    );
    rog.d('saiz bentuk --> ${bentukPerjalanan?.length}');
    bentukPerjalanan?.forEach((b) => senaraiLatLng.add(Position(b.lon, b.lat)));

    return senaraiLatLng;
  }

  Future<List<HentianEntitiData>> dapatkanKoordinatSemuaHentian() async {
    final hentianDao = HentianDao(db);
    final semuaHentian = await hentianDao.dapatkanSemua();
    rog.d('saiz hentian --> ${semuaHentian.length}');
    return await semuaHentian;
  }
}
