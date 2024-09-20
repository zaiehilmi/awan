import 'package:awan/model/jadual_bas.dart';
import 'package:awan/service/state/vm_lokal.dart';
import 'package:june/june.dart';

import '../../database/dao/berkaitan_laluan.dart';

class BasVM extends JuneState {
  List<JadualBas> senaraiLaluan = [];

  Future<void> masaKetibaan({required String bas}) async {
    bool laluanTelahWujud = senaraiLaluan.any((item) => item.kodLaluan == bas);

    if (!laluanTelahWujud) {
      final daoLaluan = DaoBerkaitanLaluan(lokalState.db);
      final jadual = await daoLaluan.jadualKetibaanMengikut(
        kodLaluan: bas,
      );

      senaraiLaluan.add(JadualBas(
        kodLaluan: bas,
        jadual: jadual ?? [],
      ));

      basState.setState();
    }
  }
}

var basState = June.getState(() => BasVM());
