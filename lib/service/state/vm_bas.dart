import 'package:awan/model/jadual_bas.dart';
import 'package:awan/service/state/vm_lokal.dart';
import 'package:june/june.dart';

import '../../database/dao/laluan_bas.dart';

class BasVM extends JuneState {
  List<JadualBas> senaraiLaluan = [];

  Future<void> masaKetibaan({required String bas}) async {
    bool laluanTelahWujud = senaraiLaluan.any((item) => item.kodLaluan == bas);

    if (!laluanTelahWujud) {
      final laluanDao = LaluanBasDao(lokalState.db);
      final senaraiKetibaan = await laluanDao.jadualKetibaanMengikut(kodLaluan: bas);

      senaraiLaluan.add(JadualBas(
        kodLaluan: bas,
        jadual: senaraiKetibaan,
      ));

      basState.setState();
    }
  }
}

var basState = June.getState(() => BasVM());
