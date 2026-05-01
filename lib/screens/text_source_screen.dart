import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'input_screen.dart';
import 'tale_select_screen.dart';

class TextSourceScreen extends StatelessWidget {
  final Map<String, String> pairs;
  final Map<String, String> buttonPairs;
  final Map<String, List<String>>? letterOptions;
  final List<List<String>>? buttonRows;
  const TextSourceScreen({
    super.key,
    required this.pairs,
    required this.buttonPairs,
    this.letterOptions,
    this.buttonRows,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('text_source'.tr())),
      body: Column(
        children: [
          ListTile(
            title: Text('insert_own_text'.tr()),
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
          ListTile(
            title: Text('folk_tale'.tr()),
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
        ],
      ),
    );
  }
}
