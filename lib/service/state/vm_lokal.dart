import 'package:awan/database/pangkalan_data.dart';
import 'package:june/june.dart';

class LokalVM extends JuneState {
  /// untuk database drift
  PangkalanDataApl db = PangkalanDataApl();

  double kemajuanMemuatkanDb = 0.0;

  void memuatkanDb({required double kemajuan}) {
    kemajuanMemuatkanDb = kemajuan;
    lokalState.setState();
  }
}

var lokalState = June.getState(() => LokalVM());
