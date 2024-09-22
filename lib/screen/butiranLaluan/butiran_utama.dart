import 'package:awan/database/dao/berkaitan_laluan.dart';
import 'package:awan/service/state/vm_lokal.dart';
import 'package:awan/theme/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../database/pangkalan_data.dart';

class LaluanButiranUtama extends HookWidget {
  final String kodLaluan;

  const LaluanButiranUtama({super.key, required this.kodLaluan});

  Widget _infoLaluan(
    BuildContext context, {
    String? petunjukLaluan,
    String? mula,
    String? akhir,
  }) {
    final waktuOperasi = '$mula - $akhir';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 60,
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kodLaluan,
              style: gayaTulisan(context).xl2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(petunjukLaluan!),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Waktu Operasi',
                    style: gayaTulisan(context).sm.copyWith(
                          color: Colors.white60,
                        ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(waktuOperasi),
                      const Gap(5),
                      Text(
                        '(masa dari titik mula)',
                        style: gayaTulisan(context)
                            .xs
                            .copyWith(fontSize: 9, color: Colors.white54),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final senaraiHentian = useState<List<WaktuBerhentiEntitiData>>([]);
    final waktuMulaOperasi = useState('');
    final waktuTamatOperasi = useState('');
    final petunjukLaluan = useState('');

    useEffect(() {
      Future<void> runAsync() async {
        final daoLaluan = DaoBerkaitanLaluan(lokalState.db);

        final temp = await daoLaluan.infoLaluanMengikut(kodLaluan: kodLaluan);
        petunjukLaluan.value = temp.petunjukLaluan ?? '';
        waktuMulaOperasi.value = temp.waktuMulaOperasi ?? '06:00';
        waktuTamatOperasi.value = temp.waktuTamatOperasi ?? '23:30';
        senaraiHentian.value = temp.senaraiHentian ?? [];
      }

      runAsync();

      return null;
    }, []);

    return SafeArea(
      top: false,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            floating: true,
            pinned: true,
            actions: [
              IconButton(
                icon: FAssets.icons.bookmark(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: FAssets.icons.map(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                color: Colors.white,
                onPressed: () {
                  context.push('/laluan_butiranUtama/$kodLaluan/petaLaluan');
                },
              ),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Tukar kandungan bergantung pada keadaan skrol
                var top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  background: _infoLaluan(
                    context,
                    petunjukLaluan: petunjukLaluan.value,
                    mula: waktuMulaOperasi.value,
                    akhir: waktuTamatOperasi.value,
                  ),
                  title: top < 120
                      ? Text(kodLaluan)
                      : null, // Tukar tajuk mengikut skrol
                );
              },
            ),
          ),
          // TODO: nak letak senarai hentian yang dilalui bas dalam laluan ni
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => FCard(
                subtitle: Text(senaraiHentian.value[index].petunjuk ?? '🐤'),
              ),
              childCount: senaraiHentian.value.length,
            ),
          ),
        ],
      ),
    );
  }
}
