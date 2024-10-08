import 'dart:async';

import 'package:awan/theme/tema.dart';
import 'package:awan/util/extension/dateTime.dart';
import 'package:awan/util/extension/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';

class PaparanRingkas extends HookWidget {
  final String kodLaluan;
  final String? namaLaluan;
  final List<DateTime> listJadual;
  final void Function()? onTap;

  const PaparanRingkas({
    super.key,
    required this.kodLaluan,
    required this.listJadual,
    this.namaLaluan,
    this.onTap,
  });

  ({int indeks, Duration? durasiUntukBasSeterusnya}) _getIndeksBasSeterusnya() {
    for (int i = 0; i < listJadual.length; i++) {
      if (listJadual[i].iaSelepasSekarang) {
        return (
          indeks: i,
          durasiUntukBasSeterusnya: listJadual[i].perbezaanMasa,
        );
      }
    }

    return (indeks: -1, durasiUntukBasSeterusnya: null);
  }

  void _updateValues(
    ValueNotifier<int> indeksTerkini,
    ValueNotifier<String> perbezaanMasa,
    ValueNotifier<String?> tibaSeterusnya,
    ValueNotifier<String?> akanTiba1,
    ValueNotifier<String?> akanTiba2,
  ) {
    final basSeterusnya = _getIndeksBasSeterusnya();

    indeksTerkini.value = basSeterusnya.indeks;

    if (basSeterusnya.indeks == -1) {
      perbezaanMasa.value = '';
    } else {
      perbezaanMasa.value =
          (basSeterusnya.durasiUntukBasSeterusnya ?? const Duration()).mesra;
    }

    tibaSeterusnya.value = _formatKetibaan(basSeterusnya.indeks);
    akanTiba1.value = _formatKetibaan(basSeterusnya.indeks + 1);
    akanTiba2.value = _formatKetibaan(basSeterusnya.indeks + 2);
  }

  String? _formatKetibaan(int indeks) {
    if (indeks == -1) {
      return null;
    } else if (indeks < listJadual.length) {
      return listJadual[indeks].format24Jam;
    } else {
      return null;
    }
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
    }, [listJadual]);

    return GestureDetector(
      onTap: onTap,
      child: FCard(
        title: Row(
          children: [
            FBadge(label: Text(kodLaluan)),
            const Gap(10),
            Expanded(
              child: Text(
                namaLaluan ?? 'data',
                style: const TextStyle(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Text(
          perbezaanMasa.value,
          style: const TextStyle(fontSize: 11.5),
        ),
        child: _jangkaanKetibaan(
          context,
          selepasIni: tibaSeterusnya.value,
          akanTiba1: akanTiba1.value,
          akanTiba2: akanTiba2.value,
          indeksTerkini: indeksTerkini.value,
        ),
      ),
    );
  }
}

Widget _jangkaanKetibaan(
  BuildContext context, {
  required String? selepasIni,
  required String? akanTiba1,
  required String? akanTiba2,
  required int indeksTerkini,
}) {
  String labelJangkaanSeterusnya;
  final gayaTulisanJamAkanTiba = gayaTulisan(context).sm.copyWith(
        color: skemaWarna(context).secondaryForeground,
        fontWeight: FontWeight.w300,
      );

  if (indeksTerkini == -1) {
    labelJangkaanSeterusnya = 'esok';
  } else {
    labelJangkaanSeterusnya = 'Jangkaan seterusnya';
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        selepasIni ?? 'Tiada bas selepas ini',
        style: (selepasIni != null)
            ? gayaTulisan(context).lg.copyWith(
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                )
            : gayaTulisan(context).xs.copyWith(height: 1.3),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelJangkaanSeterusnya,
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
        const FDivider(axis: Axis.vertical),
        Text(
          akanTiba2,
          style: gayaTulisanJamAkanTiba,
        ),
      ],
    ],
  );
}
