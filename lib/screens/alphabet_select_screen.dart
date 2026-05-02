import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AlphabetSelectScreen extends StatelessWidget {
  const AlphabetSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('choose_language'.tr()), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LanguageOption(
              label: 'russian'.tr(),
              onTap: () {
                Navigator.pushNamed(context, '/select-alphabet');
              },
            ),
            const SizedBox(height: 12),
            LanguageOption(
              label: 'english'.tr(),
              onTap: () {
                Navigator.pushNamed(context, '/select-alphabet');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const LanguageOption({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        minimumSize: const Size.fromHeight(56),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      child: Text(label),
    );
  }
}
