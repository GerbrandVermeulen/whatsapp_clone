import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/model/language.dart';
import 'package:whatsapp_clone/screens/login/verification.dart';
import 'package:whatsapp_clone/widgets/login/language_selector.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Language _selectedLanguage = languages[0];

  // Temporarily lock screen rotation
  // TODO: Make screen reactive an re-orient widgets
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final terms = [
      const TextSpan(text: 'Read our ', style: TextStyle(color: Colors.grey)),
      const TextSpan(
          text: 'Privacy Policy', style: TextStyle(color: Colors.blue)),
      const TextSpan(
          text: '. Tap \'Agree and continue\' to accept the ',
          style: TextStyle(color: Colors.grey)),
      const TextSpan(
          text: 'Terms of Service.', style: TextStyle(color: Colors.blue)),
    ];

    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.7),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 4,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/splash.png',
                    width: 340,
                    height: 340,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Text(
                    'Add an account',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.85),
                        ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text.rich(
                    TextSpan(
                      children: terms,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.onTertiaryContainer),
                    ),
                    onPressed: () async {
                      final language = await showModalBottomSheet<Language>(
                        showDragHandle: true,
                        backgroundColor:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        context: context,
                        builder: (context) {
                          return LanguageSelector(
                            selectedLanguage: _selectedLanguage,
                          );
                        },
                      );
                      if (language == null) {
                        return;
                      }
                      setState(() {
                        _selectedLanguage = language;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          _selectedLanguage.nativeName,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const VerificationScreen(),
                    ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Agree and continue',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
