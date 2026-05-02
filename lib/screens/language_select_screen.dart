import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../data/alphabets/georgian.dart';
import '../data/alphabets/georgian_button_map.dart';
import '../data/alphabets/georgian_letter_options.dart';
import '../data/alphabets/georgian_button_rows.dart';
import '../data/alphabets/hindi.dart';
import '../data/alphabets/hindi_button_map.dart';
import '../data/alphabets/hindi_letter_options.dart';
import '../data/alphabets/hindi_button_rows.dart';
import '../data/alphabets/english_to_georgian.dart';
import '../data/alphabets/english_georgian_button_map.dart';
import '../data/alphabets/english_to_hindi.dart';
import '../data/alphabets/english_hindi_button_map.dart';
import '../data/alphabets/armenian.dart';
import '../data/alphabets/armenian_button_map.dart';
import '../data/alphabets/armenian_letter_options.dart';
import '../data/alphabets/armenian_button_rows.dart';
import '../data/alphabets/english_to_armenian.dart';
import '../data/alphabets/english_armenian_button_map.dart';
import 'text_source_screen.dart';

class LanguageSelectScreen extends StatelessWidget {
  final void Function(ThemeMode)? onThemeChanged;
  final ThemeMode? themeMode;
  const LanguageSelectScreen({super.key, this.onThemeChanged, this.themeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('choose_alphabet'.tr())),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'app_title'.tr(),
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('language'.tr()),
              trailing: DropdownButton<Locale>(
                value: context.locale,
                items: [
                  DropdownMenuItem(
                    value: const Locale('ru'),
                    child: Text('russian'.tr()),
                  ),
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text('english'.tr()),
                  ),
                ],
                onChanged: (locale) {
                  if (locale != null) {
                    context.setLocale(locale);
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
              title: Text(themeMode == ThemeMode.dark ? 'dark_theme'.tr() : 'light_theme'.tr()),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (val) {
                  if (onThemeChanged != null) {
                    onThemeChanged!(val ? ThemeMode.dark : ThemeMode.light);
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text('about'.tr()),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('about'.tr()),
                    content: Text('about_text'.tr()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('ok'.tr()),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: Text('tips'.tr()),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('tips'.tr()),
                    content: Text('tips_text'.tr()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('ok'.tr()),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('georgian'.tr()),
                  onTap: () {
                    final isEnglish = context.locale.languageCode == 'en';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TextSourceScreen(
                          pairs: isEnglish ? englishToGeorgianMap : russianToGeorgianMap,
                          buttonPairs: isEnglish ? englishGeorgianButtonMap : georgianButtonMap,
                          letterOptions: georgianLetterOptions,
                          buttonRows: georgianButtonRows,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('hindi'.tr()),
                  onTap: () {
                    final isEnglish = context.locale.languageCode == 'en';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TextSourceScreen(
                          pairs: isEnglish ? englishToHindiMap : russianToHindiMap,
                          buttonPairs: isEnglish ? englishHindiButtonMap : hindiButtonMap,
                          letterOptions: hindiLetterOptions,
                          buttonRows: hindiButtonRows,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('armenian'.tr()),
                  onTap: () {
                    final isEnglish = context.locale.languageCode == 'en';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TextSourceScreen(
                          pairs: isEnglish ? englishToArmenianMap : russianToArmenianMap,
                          buttonPairs: isEnglish ? englishArmenianButtonMap : armenianButtonMap,
                          letterOptions: armenianLetterOptions,
                          buttonRows: armenianButtonRows,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('about'.tr()),
              content: Text('about_text'.tr()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('ok'.tr()),
                ),
              ],
            ),
          );
        },
        tooltip: 'about'.tr(),
        child: const Icon(Icons.help_outline),
      ),
    );
  }
}
