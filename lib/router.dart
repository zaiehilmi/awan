import 'package:awan/screen/butiranLaluan/butiran_utama.dart';
import 'package:awan/screen/tanah.dart';
import 'package:awan/util/extension/object.dart';
import 'package:go_router/go_router.dart';

final pergi = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: Tanah().namaKelas,
      builder: (context, state) {
        return Tanah();
      },
    ),
    GoRoute(
      path: '${LaluanButiranUtama().laluanRouter}/:kodLaluan',
      name: LaluanButiranUtama().namaKelas,
      builder: (context, state) {
        final kodLaluan = state.pathParameters['kodLaluan']!;
        return LaluanButiranUtama();
      },
    ),
  ],
);
