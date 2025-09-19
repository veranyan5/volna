import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:radio_player_test/data/services/storage_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GoogleSignIn signIn = GoogleSignIn.instance;

  @override
  initState() {
    super.initState();
    signinInit();
  }

  signinInit() async {
    await signIn.initialize(
      serverClientId:
          '9300496749-a6sahpt248000grrp98tkgbtp2v6sap3.apps.googleusercontent.com',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: DecoratedBox(
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
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SvgPicture.asset('assets/svg/logo.svg'),
                const SizedBox(height: 136),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(1, 7, 22, 0.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Добро пожаловать на Волну!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Введите ваше имя и войдите с помощью Гугл или Эпл аккаунта',
                        style: TextStyle(
                          color: Color(0xffF0F4FE),
                          fontSize: 10,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SignInWithAppleButton(
                        onPressed: () async {
                          try {
                            final credential =
                                await SignInWithApple.getAppleIDCredential(
                              scopes: [
                                AppleIDAuthorizationScopes.email,
                                AppleIDAuthorizationScopes.fullName,
                              ],
                            );

                            // Сохраняем данные авторизации
                            if (credential.userIdentifier != null) {
                              await StorageService.saveAuthData(
                                token: credential.identityToken ??
                                    credential.authorizationCode,
                                email: credential.email ?? '',
                                name:
                                    '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                                        .trim(),
                                authProvider: 'apple',
                              );

                              // Закрываем экран авторизации
                              if (mounted) context.pop();
                            }
                          } catch (e) {
                            print('Apple Sign In Error: $e');
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          try {
                            final GoogleSignInAccount? result =
                                await signIn.authenticate();

                            // Сохраняем данные авторизации
                            if (result != null) {
                              await StorageService.saveAuthData(
                                token: result.authentication.idToken!,
                                email: result.email,
                                name: result.displayName ?? '',
                                authProvider: 'google',
                              );

                              // Закрываем экран авторизации
                              if (mounted) context.pop();
                            }
                          } catch (e) {
                            print('Google Sign In Error: $e');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffF0F4FE), width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/svg/google.svg'),
                              const SizedBox(width: 15),
                              const Text(
                                'войти с помощью аккаунта Google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                const Text(
                  'Volna Radio 103 2FM UAE',
                  style: TextStyle(
                    color: Color(0xffF0F4FE),
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
