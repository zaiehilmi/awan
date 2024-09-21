import 'package:awan/router.dart';
import 'package:awan/service/mapbox.dart';
import 'package:awan/service/tetapan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:orange/orange.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tempDir = await getTemporaryDirectory();
  Tetapan.filePath = tempDir.path;

  // memulakan storan lokal
  await Orange.init();
  await dotenv.load();

  await memulakanMapbox();

  runApp(const Awan());
}

class Awan extends HookWidget {
  const Awan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      builder: (context, child) => FTheme(
        data: FThemes.rose.dark,
        child: child!,
      ),
      routerConfig: pergi,
    );
  }
}
