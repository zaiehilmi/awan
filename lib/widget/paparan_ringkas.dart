import 'dart:async';

import 'package:awan/theme/tema.dart';
import 'package:awan/util/extension/dateTime.dart';
import 'package:awan/util/extension/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:prasarana_rapid/prasarana_rapid.dart';

class PaparanRingkas extends HookWidget {
  final String kodLaluan;
  final String? namaLaluan;
  final String? titikA;
  final String? titikB;
  final List<WaktuBerhenti> listWaktuBerhenti;

  PaparanRingkas({
    super.key,
    required this.kodLaluan,
    this.namaLaluan,
    this.titikA,
    this.titikB,
    required this.listWaktuBerhenti,
  });

  (int, Duration?) _getIndeksBasSeterusnya() {
    DateTime sekarang = DateTime.now();

    for (int i = 0; i < listWaktuBerhenti.length; i++) {
      if (listWaktuBerhenti[i].ketibaan != null &&
          listWaktuBerhenti[i].ketibaan!.isAfter(sekarang)) {
        return (i, listWaktuBerhenti[i].ketibaan?.difference(sekarang));
      }
    }

    return (-1, null);
  }

  void _updateValues(
    ValueNotifier<int> indeksTerkini,
    ValueNotifier<String> perbezaanMasa,
    ValueNotifier<String?> tibaSeterusnya,
    ValueNotifier<String?> akanTiba1,
    ValueNotifier<String?> akanTiba2,
  ) {
    final (indeks, durasi) = _getIndeksBasSeterusnya();

    indeksTerkini.value = indeks;
    perbezaanMasa.value = (durasi ?? const Duration()).mesra;

    tibaSeterusnya.value = _formatKetibaan(indeks);
    akanTiba1.value = _formatKetibaan(indeks + 1);
    akanTiba2.value = _formatKetibaan(indeks + 2);
  }

  String? _formatKetibaan(int index) {
    return (index < listWaktuBerhenti.length)
        ? listWaktuBerhenti[index].ketibaan?.format24Jam
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final indeksTerkini = useState(0);
    final perbezaanMasa = useState('');
    final tibaSeterusnya = useState<String?>(null);
    final akanTiba1 = useState<String?>(null);
    final akanTiba2 = useState<String?>(null);

    useEffect(() {
      _updateValues(
          indeksTerkini, perbezaanMasa, tibaSeterusnya, akanTiba1, akanTiba2);

      final timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
        _updateValues(
            indeksTerkini, perbezaanMasa, tibaSeterusnya, akanTiba1, akanTiba2);
      });

      return () => timer.cancel();
    }, [listWaktuBerhenti]);

    return GestureDetector(
      onTap: () {
        print('object');
      },
      child: FCard(
        title: Row(
          children: [
            FBadge(label: Text(kodLaluan)),
            const Gap(10),
            Expanded(
              child: Text(
                listWaktuBerhenti[0].petunjuk ?? 'data',
                style: const TextStyle(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Text(
          'Jangkaan ketibaan: ${perbezaanMasa.value}',
          style: const TextStyle(fontSize: 11.5),
        ),
        child: _jangkaanKetibaan(context,
            selepasIni: tibaSeterusnya.value,
            akanTiba1: akanTiba1.value,
            akanTiba2: akanTiba2.value),
      ),
    );
  }
}

Widget _jangkaanKetibaan(
  BuildContext context, {
  required String? selepasIni,
  required String? akanTiba1,
  required String? akanTiba2,
}) {
  final gayaTulisanJamAkanTiba = gayaTulisan(context).sm.copyWith(
        color: skemaWarna(context).secondaryForeground,
        fontWeight: FontWeight.w300,
      );

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        selepasIni ?? 'Tiada bas selepas ini',
        style: gayaTulisan(context).lg.copyWith(
              height: 1.3,
              fontWeight: FontWeight.bold,
            ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jangkaan seterusnya',
            style: gayaTulisan(context).sm.copyWith(
                  color: skemaWarna(context).mutedForeground,
                  fontSize: 9,
                ),
          ),
          _jamAkanTiba(akanTiba1, gayaTulisanJamAkanTiba, akanTiba2),
        ],
      ),
    ],
  );
}

Row _jamAkanTiba(
  String? akanTiba1,
  TextStyle gayaTulisanJamAkanTiba,
  String? akanTiba2,
) {
  return Row(
    children: [
      Text(
        akanTiba1 ?? 'Tiada',
        style: gayaTulisanJamAkanTiba,
      ),
      if (akanTiba2 != null) ...[
        const FDivider(vertical: true),
        Text(
          akanTiba2,
          style: gayaTulisanJamAkanTiba,
        ),
      ],
    ],
  );
}
