import 'package:awan/widget/jubin_tetapan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SkrinTetapan extends HookWidget {
  const SkrinTetapan({super.key});

  // MARK: Komponen UI 🖼

  // MARK: Interaksi 🫵

  // MARK: Logik 🎨

  // MARK: Kitar hayat luaran ⭕

  @override
  Widget build(BuildContext context) {
    final brightnessMode = useState(false); // TODO: letak dalam Orange

    // MARK: Kitar hayat dalaman 🔴

    // MARK: Mula membina 📦

    return Column(
      children: [
        JubinTetapan(
          context,
          tajuk: "Mod Gelap",
          subTajuk: "Terokai aplikasi dengan pencahayaan berbeza",
          suisHidup: brightnessMode.value,
          onChange: (nilai) => brightnessMode.value = nilai,
        ),
      ],
    );
  }
}
