import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../logic/replacer.dart';
import '../widgets/character_pair_keyboard.dart';

class EditScreen extends StatefulWidget {
  final String initialText;
  // Mapping of Russian sequences to target letters for replacement
  final Map<String, String> pairs;
  // Mapping of target letters to their Russian phonetic equivalents
  final Map<String, String> buttonPairs;
  final Map<String, List<String>>? letterOptions;
  final List<List<String>>? buttonRows;

  const EditScreen({
    super.key,
    required this.initialText,
    required this.pairs,
    required this.buttonPairs,
    this.letterOptions,
    this.buttonRows,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final Set<String> _activeChars = <String>{};
  late String resultText;
  bool _showKeyboard = true;
  bool _keyboardCollapsed = false;

  // Настройки текста
  int _fontSizeIndex = 1; // 0:16, 1:18, 2:20, 3:22
  static const List<double> _fontSizes = [16, 18, 20, 22];
  Color _textColor = Colors.black;
  String _fontFamily = 'default';
  bool _isBold = false;

  // Цвета для светлой и тёмной темы
  List<Color> get _colorOptions {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? [Colors.white, const Color(0xFFFFF8E1)] // белый, светло-бежевый
        : [Colors.black, const Color(0xFF795548)]; // чёрный, коричневый
  }

  List<String> get _colorNames {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? ['Белый', 'Светло-бежевый'] : ['Чёрный', 'Коричневый'];
  }

  final List<String> _fontOptions = ['default', 'serif'];
  final List<String> _fontNames = ['Стандартный', 'С засечками'];

  @override
  void initState() {
    super.initState();
    resultText = widget.initialText;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Если выбран стандартный цвет, меняем его при смене темы
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color standard = isDark ? Colors.white : Colors.black;
    if (!_colorOptions.contains(_textColor) ||
        _textColor == Colors.white ||
        _textColor == Colors.black) {
      setState(() {
        _textColor = standard;
      });
    }
  }

  void _toggleCollapse() {
    setState(() {
      _keyboardCollapsed = !_keyboardCollapsed;
    });
  }

  void toggleCharacter(String char) {
    final optionMap = widget.letterOptions ?? <String, List<String>>{};
    setState(() {
      final alreadySelected = _activeChars.contains(char);
      bool inGroup = false;

      // Ensure only one option from a group is active at a time
      for (final entry in optionMap.entries) {
        if (entry.value.contains(char)) {
          inGroup = true;
          for (final opt in entry.value) {
            _activeChars.remove(opt);
          }
          break;
        }
      }

      if (alreadySelected && !inGroup) {
        _activeChars.remove(char);
      } else if (!alreadySelected) {
        _activeChars.add(char);
      }

      resultText = transformWithSelected(
        widget.initialText,
        widget.pairs,
        _activeChars,
        widget.letterOptions,
      );
    });
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void bump() {
              setState(() {});
              setModalState(() {});
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text('text_size_label'.tr()),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.text_decrease),
                        onPressed: _fontSizeIndex > 0
                            ? () {
                                if (_fontSizeIndex > 0) _fontSizeIndex--;
                                bump();
                              }
                            : null,
                      ),
                      Text('а', style: TextStyle(fontSize: _fontSizes[0])),
                      const SizedBox(width: 4),
                      Text('А', style: TextStyle(fontSize: _fontSizes.last)),
                      IconButton(
                        icon: const Icon(Icons.text_increase),
                        onPressed: _fontSizeIndex < _fontSizes.length - 1
                            ? () {
                                if (_fontSizeIndex < _fontSizes.length - 1) {
                                  _fontSizeIndex++;
                                }
                                bump();
                              }
                            : null,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('text_color_label'.tr()),
                      const SizedBox(width: 12),
                      for (int i = 0; i < _colorOptions.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _textColor = _colorOptions[i]);
                              setModalState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _isCurrentColor(i)
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.outline,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: _colorOptions[i],
                                radius: 14,
                                child: null,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('text_bold_label'.tr()),
                      Switch(
                        value: _isBold,
                        onChanged: (v) {
                          setState(() => _isBold = v);
                          setModalState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _isCurrentColor(int i) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color standard = isDark ? Colors.white : Colors.black;
    // Если выбран стандартный цвет, галочка всегда на актуальном стандартном
    if ((_textColor == Colors.white || _textColor == Colors.black) &&
        _colorOptions[i] == standard) {
      return true;
    }
    return _textColor == _colorOptions[i];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('result'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'text_settings_tooltip'.tr(),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'result_label'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    resultText,
                    style: TextStyle(
                      fontSize: _fontSizes[_fontSizeIndex],
                      color: _textColor,
                      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showKeyboard
                  ? CharacterPairKeyboard(
                      key: const ValueKey('keyboard'),
                      pairs: widget.buttonPairs,
                      activeChars: _activeChars,
                      onToggle: toggleCharacter,
                      collapsed: _keyboardCollapsed,
                      onCollapseToggle: _toggleCollapse,
                      options: widget.letterOptions,
                      rows: widget.buttonRows,
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ],
        ),
      ),
    );
  }
}
