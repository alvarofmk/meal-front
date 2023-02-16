import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:front/config/locator.dart';
import 'package:front/landing/landing_screen.dart';

void main() {
  configureDependencies();
  runApp(App());
}

class App extends MaterialApp {
  App({super.key})
      : super(
            home: const LandingScreen(), theme: ThemeData(fontFamily: 'Inter'));
}
