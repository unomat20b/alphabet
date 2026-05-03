import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/language_select_screen.dart';
import 'screens/alphabet_select_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'theme/telegram_theme.dart';

const _kThemePrefKey = 'theme_mode';

class AlfabetApp extends StatefulWidget {
  const AlfabetApp({super.key});

  @override
  State<AlfabetApp> createState() => _AlfabetAppState();
}

class _AlfabetAppState extends State<AlfabetApp> with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.system;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadThemePref();
    _initAsync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeMode == ThemeMode.system) {
      setState(() {});
    }
  }

  Future<void> _loadThemePref() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kThemePrefKey);
    if (!mounted) return;
    setState(() {
      _themeMode = switch (raw) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    });
  }

  Future<void> _initAsync() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      _initialized = true;
    });
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kThemePrefKey,
      switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      },
    );
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
