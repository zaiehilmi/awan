import 'package:awan/database/dao/berkaitan_laluan.dart';
import 'package:awan/service/state/vm_lokal.dart';
import 'package:awan/theme/tema.dart';
import 'package:awan/util/extension/dateTime.dart';
import 'package:awan/util/roggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LaluanButiranUtama extends HookWidget {
  String kodLaluan = '';

  LaluanButiranUtama({super.key, required this.kodLaluan});

  Widget _infoLaluan(
    BuildContext context, {
    DateTime? mula,
    DateTime? akhir,
  }) {
    final waktuOperasi = '${mula?.format24Jam} - ${akhir?.format24Jam}';

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
            Text('MRT Taman Equine - Taman Pinggiran Putra'),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Waktu Operasi',
                    style: gayaTulisan(context).sm.copyWith(
                          color: Colors.white54,
                        ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(waktuOperasi),
                )
              ],
            ),
            Text('data'),
            Text('data'),
            Text('data'),
            Text('data'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jadualDiTitikA = useState<List<DateTime>?>([]);

    useEffect(() {
      Future<void> runAsync() async {
        final daoLaluan = DaoBerkaitanLaluan(lokalState.db);

        jadualDiTitikA.value = await daoLaluan.jadualKetibaanMengikut(
          kodLaluan: kodLaluan,
        );
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
              FHeaderAction(
                icon: FAssets.icons.bookmark,
                onPress: () {
                  rog.d('Tekan pada penanda');
                },
              ),
              const Gap(15),
              FHeaderAction(
                icon: FAssets.icons.map,
                onPress: () {
                  context.push('/laluan_butiranUtama/$kodLaluan/petaLaluan');
                },
              ),
              const Gap(15),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Tukar kandungan bergantung pada keadaan skrol
                var top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  background: _infoLaluan(
                    context,
                    mula: jadualDiTitikA.value?.firstOrNull,
                    akhir: jadualDiTitikA.value?.lastOrNull,
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
              (context, index) =>
                  Text('${jadualDiTitikA.value?[index].format24Jam}'),
              childCount: jadualDiTitikA.value?.length,
            ),
          ),
        ],
      ),
    );
  }
}
