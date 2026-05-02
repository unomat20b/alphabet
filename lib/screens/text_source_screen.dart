import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'input_screen.dart';
import 'tale_select_screen.dart';
import 'transcription_screen.dart';
import '../widgets/telegram_section_card.dart';

class TextSourceScreen extends StatelessWidget {
  final Map<String, String> pairs;
  final Map<String, String> buttonPairs;

  /// Латиница → целевой алфавит (те же ключи, что в english_to_* карт).
  final Map<String, String> latinToTargetMap;
  final Map<String, List<String>>? letterOptions;
  final List<List<String>>? buttonRows;
  const TextSourceScreen({
    super.key,
    required this.pairs,
    required this.buttonPairs,
    required this.latinToTargetMap,
    this.letterOptions,
    this.buttonRows,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('text_source'.tr())),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          TelegramSectionCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_note_outlined),
                  title: Text('insert_own_text'.tr()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InputScreen(
                          pairs: pairs,
                          buttonPairs: buttonPairs,
                          letterOptions: letterOptions,
                          buttonRows: buttonRows,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.auto_stories_outlined),
                  title: Text('folk_tale'.tr()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaleSelectScreen(
                          pairs: pairs,
                          buttonPairs: buttonPairs,
                          letterOptions: letterOptions,
                          buttonRows: buttonRows,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.translate_outlined),
                  title: Text('transcription'.tr()),
                  subtitle: Text('transcription_subtitle'.tr()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TranscriptionScreen(
                          latinToTargetMap: latinToTargetMap,
                          letterOptions: letterOptions,
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
    );
  }
}
