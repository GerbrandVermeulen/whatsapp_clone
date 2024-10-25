class Language {
  const Language({required this.nativeName, required this.translatedName});

  final String nativeName;
  final String translatedName;
}

final languages = [
  const Language(
    nativeName: 'English',
    translatedName: 'English',
  ),
  const Language(
    nativeName: 'Afrikaans',
    translatedName: 'Afrikaans',
  ),
];
