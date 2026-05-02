import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
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
import '../data/alphabets/greek.dart';
import '../data/alphabets/greek_button_map.dart';
import '../data/alphabets/greek_letter_options.dart';
import '../data/alphabets/greek_button_rows.dart';
import '../data/alphabets/english_to_greek.dart';
import '../data/alphabets/english_greek_button_map.dart';
import 'text_source_screen.dart';
import '../widgets/telegram_section_card.dart';

final Uri _boostyDonateUri = Uri.parse('https://boosty.to/daysw/donate');

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
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'app_title'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            TelegramSectionCard(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language_outlined),
                    title: Text('language'.tr()),
                    trailing: DropdownButton<Locale>(
                      underline: const SizedBox.shrink(),
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
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      themeMode == ThemeMode.dark
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                    ),
                    title: Text(
                      themeMode == ThemeMode.dark
                          ? 'dark_theme'.tr()
                          : 'light_theme'.tr(),
                    ),
                    trailing: Switch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (val) {
                        if (onThemeChanged != null) {
                          onThemeChanged!(
                            val ? ThemeMode.dark : ThemeMode.light,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            TelegramSectionCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text('about'.tr()),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('about'.tr()),
                          content: SingleChildScrollView(
                            child: Text('about_text'.tr()),
                          ),
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
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lightbulb_outline),
                    title: Text('tips'.tr()),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('tips'.tr()),
                          content: SingleChildScrollView(
                            child: Text('tips_text'.tr()),
                          ),
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
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.volunteer_activism_outlined),
                    title: Text('donate'.tr()),
                    onTap: () async {
                      Navigator.pop(context);
                      final ok = await launchUrl(
                        _boostyDonateUri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!context.mounted || ok) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('donate_error'.tr())),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 88),
              children: [
                TelegramSectionCard(
                  child: ListTile(
                    leading: const Icon(Icons.abc_outlined),
                    title: Text('georgian'.tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      final isEnglish = context.locale.languageCode == 'en';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TextSourceScreen(
                            pairs: isEnglish
                                ? englishToGeorgianMap
                                : russianToGeorgianMap,
                            buttonPairs: isEnglish
                                ? englishGeorgianButtonMap
                                : georgianButtonMap,
                            latinToTargetMap: englishToGeorgianMap,
                            letterOptions: georgianLetterOptions,
                            buttonRows: georgianButtonRows,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TelegramSectionCard(
                  child: ListTile(
                    leading: const Icon(Icons.translate_outlined),
                    title: Text('hindi'.tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      final isEnglish = context.locale.languageCode == 'en';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TextSourceScreen(
                            pairs: isEnglish
                                ? englishToHindiMap
                                : russianToHindiMap,
                            buttonPairs: isEnglish
                                ? englishHindiButtonMap
                                : hindiButtonMap,
                            latinToTargetMap: englishToHindiMap,
                            letterOptions: hindiLetterOptions,
                            buttonRows: hindiButtonRows,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TelegramSectionCard(
                  child: ListTile(
                    leading: const Icon(Icons.font_download_outlined),
                    title: Text('armenian'.tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      final isEnglish = context.locale.languageCode == 'en';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TextSourceScreen(
                            pairs: isEnglish
                                ? englishToArmenianMap
                                : russianToArmenianMap,
                            buttonPairs: isEnglish
                                ? englishArmenianButtonMap
                                : armenianButtonMap,
                            latinToTargetMap: englishToArmenianMap,
                            letterOptions: armenianLetterOptions,
                            buttonRows: armenianButtonRows,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                TelegramSectionCard(
                  child: ListTile(
                    leading: const Icon(Icons.menu_book_outlined),
                    title: Text('greek'.tr()),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      final isEnglish = context.locale.languageCode == 'en';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TextSourceScreen(
                            pairs: isEnglish
                                ? englishToGreekMap
                                : russianToGreekMap,
                            buttonPairs: isEnglish
                                ? englishGreekButtonMap
                                : greekButtonMap,
                            latinToTargetMap: englishToGreekMap,
                            letterOptions: greekLetterOptions,
                            buttonRows: greekButtonRows,
                          ),
                        ),
                      );
                    },
                  ),
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
              content: SingleChildScrollView(child: Text('about_text'.tr())),
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
