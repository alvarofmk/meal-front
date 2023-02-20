import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/config/locator.dart';
import 'package:front/home_screen.dart';
import 'package:front/landing/landing_screen.dart';
import 'package:front/service/auth_service.dart';

import 'auth/auth_bloc.dart';

void main() {
  setupAsyncDependencies();
  configureDependencies();
  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      final authService = getIt<JwtAuthenticationService>();
      return AuthenticationBloc(authService)..add(AppLoaded());
    },
    child: App(),
  ));
}

class App extends MaterialApp {
  App({super.key})
      : super(
            home: const HomeScreen(),
            theme: ThemeData(
                colorScheme: ColorScheme(
                    brightness: Brightness.light,
                    primary: Colors.white,
                    onPrimary: Colors.red.shade700,
                    secondary: Colors.black54,
                    onSecondary: Colors.red.shade600,
                    error: Colors.red.shade900,
                    onError: Colors.white,
                    background: Colors.white,
                    onBackground: Colors.black,
                    surface: Colors.white,
                    onSurface: Colors.black),
                fontFamily: 'Inter',
                inputDecorationTheme:
                    InputDecorationTheme(focusColor: Colors.white)));
}
