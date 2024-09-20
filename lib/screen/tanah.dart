import 'dart:async';

import 'package:awan/service/state/vm_lokal.dart';
import 'package:awan/theme/tema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:june/june.dart';

import '../model/constant/jenis_perkhidmatan.dart';
import '../service/api/gtfs-statik.dart';
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

    useEffect(() {
      Future<void> runAsync() async =>
          await apiGtfsStatik(JenisPerkhidmatan.basPerantaraMrt);

      lokalState.memuatkanDb(kemajuan: 0.05);

      runAsync();

      return null;
    }, []);

    return JuneBuilder(
      () => LokalVM(),
      builder: (vm) => (vm.kemajuanMemuatkanDb < 1)
          ? FScaffold(
              content: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tahukah anda, burung boleh terbang 🕊️',
                      style: gayaTulisan(context).sm,
                    ),
                    const Gap(20),
                    FProgress(
                      value: vm.kemajuanMemuatkanDb,
                    ),
                  ],
                ),
              ),
            )
          : FScaffold(
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
            ),
    );
  }
}
