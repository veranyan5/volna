import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:radio_player_test/audio/audio_cubit.dart';
import 'package:radio_player_test/audio/audio_state.dart';
import 'package:radio_player_test/presentation/screens/auth_screen.dart';
import 'package:radio_player_test/widgets/bottom_bar.dart';
import 'package:radio_player_test/data/services/auth_service.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late final AudioCubit audioCubit;
  @override
  void initState() {
    audioCubit = context.read<AudioCubit>();
    audioCubit.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: VolnaBottomBar(
            currentIndex: 0,
            onTap: (i) async {
              HapticFeedback.heavyImpact();
              // Проверяем, есть ли токен авторизации
              final isAuthenticated = await AuthService.checkAuthStatus();

              if (isAuthenticated) {

                final userData = await AuthService.getCurrentUser();
                _showUserInfo(context, userData);
              } else {
                // Если не авторизован, показываем экран авторизации
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const Scaffold(body: AuthScreen()),
                );
              }
            }),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff010716),
                Color(0xff4169E1),
              ],
            ),
          ),
          child: BlocConsumer<AudioCubit, AudioState>(
            bloc: audioCubit,
            listener: (BuildContext context, AudioState state) {
              if (state.error != null) {}
            },
            builder: (BuildContext context, AudioState state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return buildBody(state);
            },
          ),
        ),
      ),
    );
  }

  Widget buildBody(AudioState state) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Stack(
        children: [
          // Центральная кнопка воспроизведения - всегда в центре экрана
          Center(
            child: BlocBuilder<AudioCubit, AudioState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () async {
                    state.isPlaying
                        ? await audioCubit.pauseAudio()
                        : await audioCubit.playAudio();
                  },
                  child: SvgPicture.asset(!state.isPlaying
                      ? 'assets/svg/play_off.svg'
                      : 'assets/svg/play_on.svg'),
                );
              },
            ),
          ),
          // Информация о треке - внизу экрана (только когда играет)
          Positioned(
            bottom: 150,
            left: 15,
            right: 15,
            child: BlocBuilder<AudioCubit, AudioState>(
              builder: (context, state) {
                // Показываем виджет только когда радио играет
                if (!state.isPlaying) {
                  return const SizedBox.shrink();
                }

                return Container(
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(1, 7, 22, 0.7),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Название песни
                          if (state.songName?.isNotEmpty == true)
                            Text(
                              state.songName!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 4),
                          // Исполнитель
                          if (state.artistName?.isNotEmpty == true)
                            Text(
                              state.artistName!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          // Если нет разделения, показываем полный заголовок
                          if (state.songName?.isEmpty == true &&
                              state.fullTitle?.isNotEmpty == true)
                            Text(
                              state.fullTitle!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                      const Spacer(),
                      SvgPicture.asset('assets/svg/like.svg'),
                      const SizedBox(width: 10),
                      SvgPicture.asset('assets/svg/favorites.svg'),
                      const SizedBox(width: 10),
                      SvgPicture.asset('assets/svg/dislike.svg'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUserInfo(BuildContext context, Map<String, String?> userData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff010716),
              Color(0xff4169E1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Индикатор свайпа
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Информация о пользователе
                const Text(
                  'Добро пожаловать!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (userData['name']?.isNotEmpty == true)
                  Text(
                    userData['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                if (userData['email']?.isNotEmpty == true)
                  Text(
                    userData['email']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Вход через ${userData['authProvider']?.toUpperCase() ?? 'Unknown'}',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                // Кнопка выхода
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService.signOut();
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Вы вышли из системы'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Выйти',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
