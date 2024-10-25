import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/language.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key, required this.selectedLanguage});

  final Language selectedLanguage;

  Widget _languageTile(BuildContext context, Language language) {
    return ListTile(
      leading: language == selectedLanguage
          ? Icon(
              Icons.radio_button_checked,
              color: Theme.of(context).colorScheme.primary,
            )
          : const Icon(Icons.radio_button_off_rounded),
      title: Text(
        language.nativeName,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.surface,
            ),
      ),
      subtitle: Text(
        language.translatedName,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
            ),
      ),
      onTap: () => Navigator.of(context).pop(language),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close),
          ),
          title: Text(
            'App Language',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                ),
          ),
        ),
        const Divider(
          height: 0,
          thickness: 1,
          color: Color.fromARGB(7, 158, 158, 158),
        ),
        _languageTile(context, selectedLanguage),
        ...languages
            .where((language) => selectedLanguage != language)
            .map((language) => _languageTile(context, language)),
      ],
    );
  }
}
