import 'package:flutter/material.dart';
import 'screens/language_select_screen.dart';
import 'screens/alphabet_select_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'theme/telegram_theme.dart';

class AlfabetApp extends StatefulWidget {
  const AlfabetApp({super.key});

  @override
  State<AlfabetApp> createState() => _AlfabetAppState();
}

class _AlfabetAppState extends State<AlfabetApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    // Можно добавить задержку для имитации загрузки, если нужно
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _initialized = true;
    });
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alfabet',
      theme: telegramLightTheme(),
      darkTheme: telegramDarkTheme(),
      themeMode: _themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: !_initialized
          ? const SplashScreen()
          : LanguageSelectScreen(
              onThemeChanged: setThemeMode,
              themeMode: _themeMode,
            ),
      routes: {
        '/select-language': (context) => LanguageSelectScreen(
          onThemeChanged: setThemeMode,
          themeMode: _themeMode,
        ),
        '/select-alphabet': (context) => const AlphabetSelectScreen(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/splash_logo.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.language, size: 120)),
        ),
      ),
    );
  }
}
