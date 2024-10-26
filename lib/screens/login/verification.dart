import 'package:flutter/material.dart';
import 'package:whatsapp_clone/widgets/login/verification_form.dart';

import '../home/home.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final description = [
      TextSpan(
          text:
              'WhatsUpp will need to verify your phone number. Carrier charges may apply. ',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
              )),
      TextSpan(
        text: 'What\'s my number?',
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.blue),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Enter your phone number',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.surface),
        ),
        actions: [
          PopupMenuButton(
            offset: const Offset(0, 54),
            color: Theme.of(context)
                .colorScheme
                .onTertiaryContainer
                .withOpacity(1),
            onSelected: (value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  'Link as companion device',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.surface),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Help',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.surface),
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      backgroundColor:
          Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.7),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 4,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(children: description),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const VerificationForm(),
                  ],
                ),
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
                    // TODO Push screen to enter code
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
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
