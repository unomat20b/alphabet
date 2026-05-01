import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'edit_screen.dart';

class InputScreen extends StatefulWidget {
  final Map<String, String> pairs;
  final Map<String, String> buttonPairs;
  final Map<String, List<String>>? letterOptions;
  final List<List<String>>? buttonRows;
  const InputScreen({
    super.key,
    required this.pairs,
    required this.buttonPairs,
    this.letterOptions,
    this.buttonRows,
  });

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    final text = _controller.text;
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
      appBar: AppBar(title: Text('enter_text'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'paste_or_type'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'sample_placeholder'.tr(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _start,
              child: Text('start'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

