import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router.dart';

class RecycleGangApp extends StatelessWidget {
  const RecycleGangApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'リサイクルギャング',
    debugShowCheckedModeBanner: false,
    routerConfig: router,
    locale: const Locale('ja'),
    supportedLocales: const [Locale('ja')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff15775a),
        primary: const Color(0xff15775a),
        surface: const Color(0xfff7f9f6),
      ),
      scaffoldBackgroundColor: const Color(0xfff7f9f6),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Color(0xfff7f9f6),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ),
  );
}
