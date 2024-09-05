import 'package:awan/model/jadual_bas.dart';
import 'package:june/june.dart';
import 'package:prasarana_rapid/prasarana_rapid.dart';

class BasVM extends JuneState {
  List<JadualBas> senaraiLaluan = [];

  Future<void> masaKetibaan({required String bas}) async {
    bool laluanTelahWujud = senaraiLaluan.any((item) => item.kodLaluan == bas);

    if (!laluanTelahWujud) {
      final senaraiKetibaan = await jadualKetibaan(bas: bas);

      senaraiLaluan.add(JadualBas(
        kodLaluan: bas,
        jadual: senaraiKetibaan,
      ));

      basState.setState();
    }
  }
}

var basState = June.getState(() => BasVM());
