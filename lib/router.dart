import 'package:awan/screen/butiranLaluan/butiran_utama.dart';
import 'package:awan/screen/butiranLaluan/peta_laluan.dart';
import 'package:awan/screen/tanah.dart';
import 'package:go_router/go_router.dart';

final pergi = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'tanah',
      builder: (context, state) {
        return Tanah();
      },
    ),
    GoRoute(
      path: '/laluan_butiranUtama/:kodLaluan',
      name: 'laluan_butiranUtama',
      builder: (context, state) {
        final kodLaluan = state.pathParameters['kodLaluan']!;
        return LaluanButiranUtama(kodLaluan: kodLaluan);
      },
      routes: [
        GoRoute(
            path: 'petaLaluan',
            name: 'petaLaluan',
            builder: (context, state) {
              final kodLaluan = state.pathParameters['kodLaluan'];
              return Peta(kodLaluan: kodLaluan ?? 'T542');
            })
      ],
    ),
  ],
);
