import 'package:flutter/material.dart';

class AlphabetButton extends StatelessWidget {
  final String letter;
  final VoidCallback? onTap;

  const AlphabetButton({
    super.key,
    required this.letter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(fontSize: 24),
      ),
      child: Text(letter),
    );
  }
}