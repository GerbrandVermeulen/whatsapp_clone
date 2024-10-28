import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:whatsapp_clone/screens/login/verification.dart';
import 'package:whatsapp_clone/util/alert.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _countryCodeController =
      TextEditingController(text: '27');
  final TextEditingController _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      final rawNumber =
          '+${_countryCodeController.text}${_numberController.text}';
      try {
        PhoneNumber phoneNumber =
            await PhoneNumber.getRegionInfoFromPhoneNumber(rawNumber);
        print('Phone number ${phoneNumber.phoneNumber}');
        if (phoneNumber.phoneNumber == null) {
          throw const FormatException();
        }
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VerificationScreen(
            phoneNumber: phoneNumber.phoneNumber!,
          ),
        ));
      } catch (e) {
        _showInvalidNumberDialog(rawNumber);
        return;
      }
    }
  }

  void _showInvalidNumberDialog(String rawNumber) {
    showNotificationDalog(
        context: context,
        message:
            '$rawNumber does not contain a valid country calling code or phone number',
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]);
  }

  Widget _verificationForm() {
    return SizedBox(
      width: 240,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField(
              dropdownColor: Theme.of(context).colorScheme.onTertiaryContainer,
              isExpanded: true,
              // isDense: true,
              decoration: InputDecoration(
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Colors.black),
              ),
              onChanged: (value) {
                // Not gonna support other countries for now
              },
              onSaved: (newValue) {
                // Not gonna support other countries for now
              },
              items: [
                DropdownMenuItem(
                  alignment: Alignment.center,
                  child: Text(
                    'South Africa',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.8)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _countryCodeController,
                    maxLength: 4,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixText: '+ ',
                      prefixStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(0.5)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      isDense: true,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.8)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a country code';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _numberController,
                    maxLength: 17,
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: 'Phone number',
                      isDense: true,
                    ),
                    keyboardType: TextInputType.phone,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.8)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

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
      backgroundColor:
          Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.7),
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
                    _verificationForm(),
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
                  onPressed: _submitPhoneNumber,
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
