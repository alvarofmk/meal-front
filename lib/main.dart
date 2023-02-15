import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:front/config/locator.dart';
import 'package:front/landing/landing_screen.dart';

void main() {
  configureDependencies();
  runApp(const App());
}

class App extends MaterialApp {
  const App({super.key}) : super(home: const LandingScreen());
}
