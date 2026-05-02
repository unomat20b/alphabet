import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../logic/replacer.dart';

/// Латинская романизация (SMS, «греклиш» и т.п.) → выбранный алфавит.
class TranscriptionScreen extends StatefulWidget {
  final Map<String, String> latinToTargetMap;
  final Map<String, List<String>>? letterOptions;

  const TranscriptionScreen({
    super.key,
    required this.latinToTargetMap,
    this.letterOptions,
  });

  @override
  State<TranscriptionScreen> createState() => _TranscriptionScreenState();
}

class _TranscriptionScreenState extends State<TranscriptionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _convert() {
    setState(() {
      _result = transformText(
        _controller.text,
        widget.latinToTargetMap,
        widget.letterOptions,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('transcription'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'transcription_hint'.tr(),
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 6,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                hintText: 'transcription_placeholder'.tr(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _convert, child: Text('transcribe'.tr())),
            const SizedBox(height: 16),
            Text(
              'result_label'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: SelectableText(
                    _result.isEmpty ? '—' : _result,
                    style: TextStyle(color: scheme.onSurface),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _result.isEmpty
                  ? null
                  : () async {
                      await Clipboard.setData(ClipboardData(text: _result));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('copied'.tr())));
                    },
              icon: const Icon(Icons.copy_outlined),
              label: Text('copy_result'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
