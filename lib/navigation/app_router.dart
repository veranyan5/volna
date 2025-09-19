import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radio_player_test/audio/audio_screen.dart';
import 'package:radio_player_test/presentation/screens/auth_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String player = '/player';
  static const String auth = '/auth';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const AudioScreen(),
      ),
      GoRoute(
        path: player,
        name: 'player',
        builder: (context, state) => const AudioScreen(),
      ),
      GoRoute(
        path: auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
    ],
  );
}





