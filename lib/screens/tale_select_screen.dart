import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:easy_localization/easy_localization.dart';

import 'edit_screen.dart';

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
  late Future<List<_Tale>> _talesFuture;

  @override
  void initState() {
    super.initState();
    _talesFuture = _loadTales();
  }

  Future<List<_Tale>> _loadTales() async {
    const assets = [
      'lib/data/tails/Text1.md',
      'lib/data/tails/Text2.md',
      'lib/data/tails/Text3.md',
      'lib/data/tails/Text4.md',
    ];
    final tales = <_Tale>[];
    for (final asset in assets) {
      final data = await rootBundle.loadString(asset);
      final title = data.split('\n').first.replaceAll('#', '').trim();
      tales.add(_Tale(asset, title));
    }
    return tales;
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
          return ListView.builder(
            itemCount: tales.length,
            itemBuilder: (context, index) {
              final tale = tales[index];
              return ListTile(
                title: Text(tale.title),
                onTap: () => _openTale(tale.asset),
              );
            },
          );
        },
      ),
    );
  }
}

