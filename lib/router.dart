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
  ],

);
