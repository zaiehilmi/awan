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
import 'index.dart';

class Tanah extends HookWidget {
  Tanah({super.key});

  final headers = [
    null,
    const FHeader(title: Text('Kalkulator Tambang')),
    const FHeader(title: Text('Gelintar')),
    FHeader(
      title: const Text('Tetapan'),
      actions: [
        FHeaderAction(
          icon: FIcon(FAssets.icons.ellipsis),
          onPress: () {},
        ),
      ],
    ),
  ];

  final contents = [
    PetaUtama(),
    const SkrinKiraTambang(),
    const SkrinGelintar(),
    SkrinTetapan(),
  ];

  @override
  Widget build(BuildContext context) {
    final tema = context.theme;
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
              style: tema.scaffoldStyle.copyWith(
                contentPadding: (bottomNavIndex.value == 0)
                    ? const EdgeInsets.only(left: 0, right: 0)
                    : const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              header: headers[bottomNavIndex.value],
              content: contents[bottomNavIndex.value],
              footer: FBottomNavigationBar(
                index: bottomNavIndex.value,
                onChange: (index) {
                  bottomNavIndex.value = index;
                },
                children: [
                  FBottomNavigationBarItem(
                    icon: FIcon(FAssets.icons.mapPinned),
                    label: const Text('Utama'),
                  ),
                  FBottomNavigationBarItem(
                    icon: FIcon(FAssets.icons.calculator),
                    label: const Text('Kira Tambang'),
                  ),
                  FBottomNavigationBarItem(
                    icon: FIcon(FAssets.icons.search),
                    label: const Text('Gelintar'),
                  ),
                  FBottomNavigationBarItem(
                    icon: FIcon(FAssets.icons.settings),
                    label: const Text('Tetapan'),
                  ),
                ],
              ),
            ),
    );
  }
}
