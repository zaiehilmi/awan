import 'package:awan/database/dao/entiti/laluan_bas.dart';
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

  @override
  Widget build(BuildContext context) {
    final semuaLaluanInit = useState(false);
    final senaraiLaluan = useState<Map<String, String>>({});
    final ruangGelintarController = useTextEditingController();

    useEffect(() {
      Future<void> initAsync() async {
        final laluanDao = LaluanBasDao(lokalState.db);

        senaraiLaluan.value = await laluanDao.semuaLaluan();
        semuaLaluanInit.value = true;
      }

      if (!semuaLaluanInit.value) {
        initAsync();
      }

      return null;
    }, [semuaLaluanInit.value]);

    Widget paparSenaraiLaluan() {
      final gayaKad = FCardStyle(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: skemaWarna(context).border,
            width: 1,
          )),
        ),
        content: FCardContentStyle.inherit(
          colorScheme: skemaWarna(context),
          typography: gayaTulisan(context),
        ),
      );

      return ListView.builder(
          itemCount: senaraiLaluan.value.entries.length,
          itemBuilder: (context, index) {
            final entri = senaraiLaluan.value.entries.toList();
            final MapEntry<String, String> item = entri[index];

            return GestureDetector(
              onTap: () {
                rog.i('Tekan ${item.key}');
                context.go('/butiranLaluan');
              },
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
            child: paparSenaraiLaluan(),
          ),
        ),
      ],
    );
  }
}
