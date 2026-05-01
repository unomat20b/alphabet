import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AlphabetSelectScreen extends StatelessWidget {
  const AlphabetSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose_language'.tr()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LanguageOption(
              label: 'russian'.tr(),
              onTap: () {
                // TODO: сохранить выбор языка (например, в Provider или SharedPreferences)
                Navigator.pushNamed(context, '/select-alphabet');
              },
            ),
            const SizedBox(height: 20),
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

  const LanguageOption({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        minimumSize: const Size.fromHeight(60),
        textStyle: const TextStyle(fontSize: 20),
      ),
      child: Text(label),
    );
  }
}

