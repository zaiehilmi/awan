import 'dart:async';

import 'package:awan/util/extension_dateTime.dart';
import 'package:awan/util/extension_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:prasarana_rapid/prasarana_rapid.dart';

class PaparanRingkas extends HookWidget {
  String kodLaluan;
  String? namaLaluan;
  String? titikA;
  String? titikB;
  List<WaktuBerhenti> listWaktuBerhenti;

  PaparanRingkas({
    super.key,
    required this.kodLaluan,
    this.namaLaluan,
    this.titikA,
    this.titikB,
    required this.listWaktuBerhenti,
  });

  (int, Duration?) getIndeksBasSeterusnyaDariSekarang(
      List<WaktuBerhenti> list) {
    DateTime sekarang = DateTime.now();

    for (int i = 0; i < list.length; i++) {
      if (list[i].ketibaan != null && list[i].ketibaan!.isAfter(sekarang)) {
        final perbezaanMasa = list[i].ketibaan?.difference(sekarang);

        return (i, perbezaanMasa);
      }
    }

    return (-1, null);
  }

  void _updateValues(
    ValueNotifier<int> indeksTerkini,
    ValueNotifier<String> perbezaanMasa,
    ValueNotifier<String> formatMasa,
  ) {
    final hasil = getIndeksBasSeterusnyaDariSekarang(listWaktuBerhenti);

    indeksTerkini.value = hasil.$1;
    perbezaanMasa.value = (hasil.$2 ?? const Duration()).mesra;
    formatMasa.value = listWaktuBerhenti.isNotEmpty
        ? listWaktuBerhenti[hasil.$1].ketibaan!.format24Jam
        : DateTime.now().format24Jam;
  }

  @override
  Widget build(BuildContext context) {
    final indeksTerkini = useState(0);
    final perbezaanMasa = useState('');
    final formatMasa = useState('');

    useEffect(() {
      _updateValues(indeksTerkini, perbezaanMasa, formatMasa);

      final timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
        _updateValues(indeksTerkini, perbezaanMasa, formatMasa);
      });

      return () {
        timer.cancel();
      };
    }, [listWaktuBerhenti]);

    return FCard(
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
            )
          ],
        ),
        subtitle: Text(
          'Bas seterusnya akan tiba ${perbezaanMasa.value}',
          style: const TextStyle(fontSize: 11.5),
        ),
        child: FCard(
          subtitle: const Text(
            'Sudah berlepas',
            style: TextStyle(fontSize: 9.5),
          ),
          child: Text(
            formatMasa.value,
            style: const TextStyle(fontSize: 11),
          ),
        ));
  }
}
