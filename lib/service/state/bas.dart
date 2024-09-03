import 'package:june/june.dart';
import 'package:prasarana_rapid/prasarana_rapid.dart';

class BasVM extends JuneState {
  List<WaktuBerhenti> senaraiLaluan = [];
  List<WaktuBerhenti> T818 = [];
  List<WaktuBerhenti> T852 = [];

  Future<void> masaKetibaanBasT542() async {
    if (senaraiLaluan.isEmpty) {
      senaraiLaluan = await masaKetibaanBas('T542');

      // await kemaskiniKetibaanSeterusnyaBasT542();
      basState.setState();
    }
  }

  Future<void> masaKetibaanBasT818() async {
    if (T818.isEmpty) {
      T818 = await masaKetibaanBas('T818');

      basState.setState();
    }
  }

  Future<void> masaKetibaanBasT852() async {
    if (T852.isEmpty) {
      T852 = await masaKetibaanBas('T852');

      basState.setState();
    }
  }
}

var basState = June.getState(() => BasVM());
