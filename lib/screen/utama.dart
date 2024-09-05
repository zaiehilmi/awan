import 'package:awan/service/state/vm_bas.dart';
import 'package:awan/widget/paparan_ringkas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:june/june.dart';
import 'package:prasarana_rapid/prasarana_rapid.dart';

class SkrinUtama extends HookWidget {
  const SkrinUtama({super.key});

  @override
  Widget build(BuildContext context) {
    // Hook to wait for fetchPrasaranaApi to complete
    final basInitialized = useState(false);
    final lala = useState<WaktuBerhenti?>(null);

    useEffect(() {
      Future<void> initBasState() async {
        await basState.masaKetibaan(bas: 'T542');
        await basState.masaKetibaan(bas: 'T818');
        await basState.masaKetibaan(bas: 'T852');

        print('Bas Initialized');
        basInitialized.value = true;
      }

      if (!basInitialized.value) {
        initBasState();
      }
    }, [basInitialized.value]); // depend on basInitialized value to run once

    if (!basInitialized.value) {
      return const Center(
          child: CupertinoActivityIndicator()); // Show loading while waiting
    }

    return FScaffold(
      content: JuneBuilder(
        () => BasVM(),
        builder: (vm) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PaparanRingkas(
              kodLaluan: 'T542',
              namaLaluan: 'Rumah',
              listJadual: vm.senaraiLaluan
                  .where((e) => e.kodLaluan == 'T542')
                  .first
                  .jadual,
              onTap: () {
                print('lala');
              },
            ),
            const Gap(10),
            PaparanRingkas(
              kodLaluan: 'T818',
              namaLaluan: 'Gi Office 😭',
              listJadual: vm.senaraiLaluan
                  .where((e) => e.kodLaluan == 'T818')
                  .first
                  .jadual,
            ),
            const Gap(10),
            PaparanRingkas(
              kodLaluan: 'T852',
              namaLaluan: 'Gi Office 😭',
              listJadual: vm.senaraiLaluan
                  .where((e) => e.kodLaluan == 'T852')
                  .first
                  .jadual,
            ),
          ],
        ),
      ),
    );
  }
}
