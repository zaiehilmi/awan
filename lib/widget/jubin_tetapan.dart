import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';

import '../theme/tema.dart';

class JubinTetapan extends HookWidget {
  final BuildContext context;
  final String tajuk;
  String? subTajuk;
  final bool suisHidup;
  final ValueChanged<bool> onChange;

  JubinTetapan(
    this.context, {
    super.key,
    required this.tajuk,
    this.subTajuk,
    required this.suisHidup,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return FCard.raw(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tajuk,
                    style: dataTema(context).typography.base.copyWith(
                          fontWeight: FontWeight.w500,
                          color: dataTema(context).colorScheme.foreground,
                          height: 1.5,
                        ),
                  ),
                  if (subTajuk != null)
                    Text(
                      subTajuk!,
                      style: dataTema(context).typography.sm.copyWith(
                          color: dataTema(context).colorScheme.mutedForeground),
                    ),
                ],
              ),
            ),
            FSwitch(
              value: suisHidup,
              onChange: onChange,
            )
          ],
        ),
      ),
    );
  }
}
