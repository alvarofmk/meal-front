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
      : super(home: const HomeScreen(), theme: ThemeData(fontFamily: 'Inter'));
}
