import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radio_player_test/audio/audio_cubit.dart';
import 'package:radio_player_test/audio/audio_handler.dart';
import 'package:radio_player_test/firebase_options.dart';
import 'package:radio_player_test/navigation/app_router.dart';
import 'package:radio_player_test/data/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
  );

  final isAuthenticated = await AuthService.checkAuthStatus();
  if (isAuthenticated) {
    final userData = await AuthService.getCurrentUser();
    print(
        'User is authenticated: ${userData['email']} via ${userData['authProvider']}');
  } else {
    print('User is not authenticated');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AudioCubit(MyAudioHandler()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Radio Player',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
