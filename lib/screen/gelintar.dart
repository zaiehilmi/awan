import 'package:awan/database/dao/berkaitan_laluan.dart';
import 'package:awan/service/state/vm_lokal.dart';
import 'package:awan/theme/tema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../util/roggle.dart';

class SkrinGelintar extends HookWidget {
  const SkrinGelintar({super.key});

  // MARK: Komponen UI 🖼

  Widget paparSenaraiLaluan(
    BuildContext context, {
    required Map<String, String> senarai,
  }) {
    final gayaKad = FCardStyle(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: skemaWarna(context).border,
          width: 1,
        )),
      ),
      contentStyle: FCardContentStyle.inherit(
        colorScheme: skemaWarna(context),
        typography: gayaTulisan(context),
      ),
    );

    return ListView.builder(
        itemCount: senarai.entries.length,
        itemBuilder: (context, index) {
          final entri = senarai.entries.toList();
          final MapEntry<String, String> item = entri[index];

          return GestureDetector(
            onTap: () => onTapSenarai(context, item: item),
            child: FCard(
              style: gayaKad,
              title: Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: FBadge(label: Text(item.key)),
                  ),
                  const Gap(20),
                  Expanded(
                    child: Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.value,
                        style: gayaTulisan(context).sm.copyWith(
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: skemaWarna(context).secondaryForeground),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  // MARK: Interaksi 🫵

  void onTapSenarai(
    BuildContext context, {
    required MapEntry<String, String> item,
  }) {
    rog.i('Tekan ${item.key}');
    context.push(
      '/laluan_butiranUtama/${item.key}',
    );
  }

  // MARK: Logik 🎨

  // MARK: Kitar hayat luaran ⭕

  @override
  Widget build(BuildContext context) {
    final semuaLaluanInit = useState(false);
    final senaraiLaluan = useState<Map<String, String>>({});
    final ruangGelintarController = useTextEditingController();

    // MARK: Kitar hayat dalaman 🔴

    useEffect(() {
      Future<void> initAsync() async {
        final daoLaluan = DaoBerkaitanLaluan(lokalState.db);

        senaraiLaluan.value = await daoLaluan.semuaLaluan();
        semuaLaluanInit.value = true;
      }

      if (!semuaLaluanInit.value) {
        initAsync();
      }

      return null;
    }, [semuaLaluanInit.value]);

    // MARK: Mula membina 📦

    if (!semuaLaluanInit.value) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return Column(
      children: [
        SizedBox(
          // bawak dia turun bawah nanti
          height: 70,
          child: Center(
            child: FTextField(
              controller: ruangGelintarController,
              hint: 'Cari laluan bas',
              maxLines: 1,
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            radius: const Radius.circular(10),
            thumbVisibility: true,
            child: paparSenaraiLaluan(
              context,
              senarai: senaraiLaluan.value,
            ),
          ),
        ),
      ],
    );
  }
}
