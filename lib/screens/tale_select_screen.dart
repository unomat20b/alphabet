import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:easy_localization/easy_localization.dart';

import 'edit_screen.dart';
import '../widgets/telegram_section_card.dart';

const _kTalesRu = [
  'lib/data/tails/tail_ru_kolobok.md',
  'lib/data/tails/tail_ru_doch_semiletka.md',
  'lib/data/tails/tail_ru_kalinov_most.md',
  'lib/data/tails/tail_ru_soldat_i_czarica.md',
];

const _kTalesEn = [
  'lib/data/tails/tail_en_little_red_riding_hood.md',
  'lib/data/tails/tail_en_goldilocks.md',
  'lib/data/tails/tail_en_gingerbread_man.md',
  'lib/data/tails/tail_en_ugly_duckling.md',
];

class TaleSelectScreen extends StatefulWidget {
  final Map<String, String> pairs;
  final Map<String, String> buttonPairs;
  final Map<String, List<String>>? letterOptions;
  final List<List<String>>? buttonRows;
  const TaleSelectScreen({
    super.key,
    required this.pairs,
    required this.buttonPairs,
    this.letterOptions,
    this.buttonRows,
  });

  @override
  State<TaleSelectScreen> createState() => _TaleSelectScreenState();
}

class _Tale {
  final String asset;
  final String title;
  const _Tale(this.asset, this.title);
}

class _TaleSelectScreenState extends State<TaleSelectScreen> {
  Future<List<_Tale>>? _talesFuture;
  String? _loadedForLang;

  List<String> _assetsForLocale(Locale locale) {
    return locale.languageCode == 'en' ? _kTalesEn : _kTalesRu;
  }

  Future<List<_Tale>> _loadTales(Locale locale) async {
    final assets = _assetsForLocale(locale);
    final tales = <_Tale>[];
    for (final asset in assets) {
      final data = await rootBundle.loadString(asset);
      final title = data.split('\n').first.replaceAll('#', '').trim();
      tales.add(_Tale(asset, title));
    }
    return tales;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = context.locale.languageCode;
    if (_loadedForLang != lang) {
      _loadedForLang = lang;
      _talesFuture = _loadTales(context.locale);
    }
  }

  Future<void> _openTale(String asset) async {
    final text = await rootBundle.loadString(asset);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditScreen(
          initialText: text,
          pairs: widget.pairs,
          buttonPairs: widget.buttonPairs,
          letterOptions: widget.letterOptions,
          buttonRows: widget.buttonRows,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('folk_tales'.tr())),
      body: FutureBuilder<List<_Tale>>(
        future: _talesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final tales = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            children: [
              TelegramSectionCard(
                child: Column(
                  children: [
                    for (var i = 0; i < tales.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      ListTile(
                        title: Text(tales[i].title),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _openTale(tales[i].asset),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
