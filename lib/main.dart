import 'package:awan/screen/index.dart';
import 'package:awan/service/api/gtfs-statik.dart';
import 'package:awan/service/tetapan.dart';
import 'package:awan/util/roggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:path_provider/path_provider.dart';

import 'model/constant/jenis_perkhidmatan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tempDir = await getTemporaryDirectory();
  Tetapan.filePath = tempDir.path;

  await apiGtfsStatik(JenisPerkhidmatan.basPerantaraMrt);
  // await fetchPrasaranaApi(JenisPerkhidmatan.basKL);

  runApp(Awan());
}

class Awan extends HookWidget {
  Awan({super.key});

  final headers = [
    const FHeader(title: Text('🌥️')),
    const FHeader(title: Text('Kalkulator Tambang')),
    const FHeader(title: Text('Gelintar')),
    FHeader(
      title: const Text('Tetapan'),
      actions: [
        FHeaderAction(
          icon: FAssets.icons.ellipsis,
          onPress: () {},
        ),
      ],
    ),
  ];

  final contents = [
    SkrinUtama(),
    SkrinKiraTambang(),
    SkrinGelintar(),
    SkrinTetapan(),
  ];

  @override
  Widget build(BuildContext context) {
    useAnimationController(duration: const Duration(seconds: 2));
    final _bottomNavIndex = useState(0);

    useEffect(() {
      rog.i('init dalam Awan');
    }, []);

    return MaterialApp(
      themeMode: ThemeMode.system,
      builder: (context, child) => FTheme(
        data: FThemes.rose.dark,
        child: child!,
      ),
      home: FScaffold(
        header: headers[_bottomNavIndex.value],
        content: contents[_bottomNavIndex.value],
        footer: FBottomNavigationBar(
          index: _bottomNavIndex.value,
          onChange: (index) {
            _bottomNavIndex.value = index;
          },
          items: [
            FBottomNavigationBarItem(
              icon: FAssets.icons.home,
              label: 'Utama',
            ),
            FBottomNavigationBarItem(
              icon: FAssets.icons.calculator,
              label: 'Kira Tambang',
            ),
            FBottomNavigationBarItem(
              icon: FAssets.icons.search,
              label: 'Gelintar',
            ),
            FBottomNavigationBarItem(
              icon: FAssets.icons.settings,
              label: 'Tetapan',
            ),
          ],
        ),
      ),
    );
  }
}
