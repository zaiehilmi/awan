import 'package:awan/database/dao/berkaitan_laluan.dart';
import 'package:awan/service/state/vm_lokal.dart';
import 'package:awan/theme/tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../database/pangkalan_data.dart';

class LaluanButiranUtama extends HookWidget {
  final String kodLaluan;

  const LaluanButiranUtama({super.key, required this.kodLaluan});

  // MARK: Komponen UI 🖼

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
            const Gap(15),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Waktu Operasi',
                    style: gayaTulisan(context).xs.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        waktuOperasi,
                        style: gayaTulisan(context).xs,
                      ),
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

  // MARK: Interaksi 🫵
  void onTapLihatLaluan(BuildContext context) {
    context.push('/laluan_butiranUtama/$kodLaluan/petaLaluan');
  }

  void onTapPenanda() {}

  // MARK: Logik 🎨

  // MARK: Kitar hayat luaran ⭕

  @override
  Widget build(BuildContext context) {
    final senaraiHentian = useState<List<WaktuBerhentiEntitiData>>([]);
    final waktuMulaOperasi = useState('');
    final waktuTamatOperasi = useState('');
    final petunjukLaluan = useState('');

    // MARK: Kitar hayat dalaman 🔴

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

    // MARK: Mula membina 📦

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
                onPressed: () => onTapPenanda(),
              ),
              IconButton(
                icon: FAssets.icons.map(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                color: Colors.white,
                onPressed: () => onTapLihatLaluan(context),
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
          SliverToBoxAdapter(
            child: FixedTimeline.tileBuilder(
              theme: TimelineThemeData(
                nodePosition: 0,
                direction: Axis.vertical,
                nodeItemOverlap: true,
                connectorTheme: ConnectorThemeData(
                  thickness: 15,
                  color: skemaWarna(context).border,
                  space: 50,
                ),
                indicatorTheme: IndicatorThemeData(
                  color: skemaWarna(context).primary,
                ),
              ),
              builder: TimelineTileBuilder.connected(
                itemCount: senaraiHentian.value.length,
                indicatorBuilder: (_, index) => const OutlinedDotIndicator(
                  backgroundColor: Color(0xfff5d4d7),
                  borderWidth: 4,
                ),
                connectorBuilder: (_, index, connectorType) =>
                    const SolidLineConnector(),
                contentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            senaraiHentian.value[index].petunjuk ?? '🐤',
                            style: gayaTulisan(context).sm,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
