import 'package:awan/database/pangkalan_data.dart';
import 'package:june/june.dart';

class LokalVM extends JuneState {
  /// untuk database drift
  AppDatabase db = AppDatabase();
}

var lokalState = June.getState(() => LokalVM());
