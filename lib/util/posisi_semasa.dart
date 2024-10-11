import 'package:awan/util/roggle.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Position?> dapatkanPosisiSemasa(BuildContext context) async {
  var status = await Permission.locationWhenInUse.status;

  if (status.isDenied) {
    status = await Permission.locationWhenInUse.request();
    if (status.isDenied) {
      return null;
    }
  }

  if (status.isGranted) {
    return await Geolocator.getCurrentPosition();
  }

  return null;
}

Future<void> tunjukDialogKepastian(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return FDialog(
        title: const Text('Anda pasti?'),
        body: const Text('Akses lokasi telah dihalang oleh anda.'),
        actions: [
          FButton(
            onPress: () {
              rog.i('memang taknak bagi akses');
              Navigator.of(context).pop();
            },
            style: FButtonStyle.outline,
            label: const Text('OK'),
          ),
          FButton(
            onPress: () async {
              rog.i('Memilih "tanya akses sekali lagi"');
              Navigator.of(context).pop();
              await openAppSettings();
            },
            label: const Text('Buka Seting'),
          ),
        ],
      );
    },
  );
}
