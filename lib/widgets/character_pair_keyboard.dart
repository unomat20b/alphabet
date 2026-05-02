import 'package:flutter/material.dart';

class CharacterPairKeyboard extends StatelessWidget {
  final Map<String, String> pairs; // Target letter -> Russian pronunciation
  final Set<String> activeChars; // Selected target letters
  final ValueChanged<String> onToggle;
  final bool collapsed;
  final VoidCallback onCollapseToggle;
  final Map<String, List<String>>? options; // Base letter -> possible letters
  final List<List<String>>? rows;

  const CharacterPairKeyboard({
    super.key,
    required this.pairs,
    required this.activeChars,
    required this.onToggle,
    required this.collapsed,
    required this.onCollapseToggle,
    this.options,
    this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final optionMap = options ?? <String, List<String>>{};
    final skip = optionMap.values.expand((list) => list.skip(1)).toSet();
    final Map<String, Set<String>> grouped = {};
    for (final entry in pairs.entries) {
      final geo = entry.key;
      if (skip.contains(geo)) continue;

      if (optionMap.containsKey(geo)) {
        final ruSet = <String>{};
        for (final opt in optionMap[geo]!) {
          final ru = pairs[opt]?.toUpperCase();
          if (ru != null) ruSet.add(ru);
        }
        grouped[geo] = ruSet;
      } else {
        final ru = entry.value.toUpperCase();
        grouped[geo] = {ru};
      }
    }

    final toggleButton = _KeyboardToggleButton(
      active: collapsed,
      onPressed: onCollapseToggle,
    );

    if (collapsed) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [toggleButton],
      );
    }

    if (rows != null && rows!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final row in rows!)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final char in row)
                    if (grouped.containsKey(char))
                      _CharacterButton(
                        georgian: char,
                        russian: grouped[char]!.join(', '),
                        options: optionMap[char],
                        active: optionMap.containsKey(char)
                            ? optionMap[char]!.any(
                                (c) => activeChars.contains(c),
                              )
                            : activeChars.contains(char),
                        onToggle: onToggle,
                      ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [toggleButton],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final entry in grouped.entries)
              _CharacterButton(
                georgian: entry.key,
                russian: entry.value.join(', '),
                options: optionMap[entry.key],
                active: optionMap.containsKey(entry.key)
                    ? optionMap[entry.key]!.any((c) => activeChars.contains(c))
                    : activeChars.contains(entry.key),
                onToggle: onToggle,
              ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [toggleButton]),
      ],
    );
  }
}

class _CharacterButton extends StatelessWidget {
  final String georgian;
  final String russian;
  final List<String>? options;
  final ValueChanged<String> onToggle;
  final bool active;

  const _CharacterButton({
    required this.georgian,
    required this.russian,
    required this.active,
    required this.onToggle,
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton(
      onPressed: () async {
        if (options != null && options!.length > 1) {
          final selected = await showDialog<String>(
            context: context,
            builder: (context) => SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              children: [
                for (final opt in options!)
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, opt),
                    child: Text(opt, textAlign: TextAlign.center),
                  ),
              ],
            ),
          );
          if (selected != null) onToggle(selected);
        } else {
          onToggle(options?.first ?? georgian);
        }
      },
      style: FilledButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        backgroundColor: active
            ? scheme.primaryContainer
            : scheme.surfaceContainerHigh,
        foregroundColor: active ? scheme.onPrimaryContainer : scheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(russian, style: const TextStyle(fontSize: 12)),
          Text(
            georgian,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _KeyboardToggleButton extends StatelessWidget {
  final bool active;
  final VoidCallback onPressed;

  const _KeyboardToggleButton({required this.active, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        backgroundColor: active
            ? scheme.primaryContainer
            : scheme.surfaceContainerHigh,
        foregroundColor: active ? scheme.onPrimaryContainer : scheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        '⌨️',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
