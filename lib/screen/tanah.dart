import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';

import 'gelintar.dart';
import 'kira_tambang.dart';
import 'tetapan.dart';
import 'utama.dart';

class Tanah extends HookWidget {
  Tanah({super.key});

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
    const SkrinUtama(),
    const SkrinKiraTambang(),
    const SkrinGelintar(),
    SkrinTetapan(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavIndex = useState(0);

    return FScaffold(
      header: headers[bottomNavIndex.value],
      content: contents[bottomNavIndex.value],
      footer: FBottomNavigationBar(
        index: bottomNavIndex.value,
        onChange: (index) {
          bottomNavIndex.value = index;
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
    );
  }
}
