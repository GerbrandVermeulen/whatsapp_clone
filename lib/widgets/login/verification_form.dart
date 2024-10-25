import 'package:flutter/material.dart';

class VerificationForm extends StatefulWidget {
  const VerificationForm({super.key});

  @override
  State<VerificationForm> createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  final TextEditingController _countryController =
      TextEditingController(text: '27');
  final TextEditingController _numberController = TextEditingController();

  late GlobalKey _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _countryController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Form(
        key: _key,
        child: Column(
          children: [
            DropdownButtonFormField(
              isExpanded: true,
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(
                      prefixText: '+ ',
                      prefixStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(0.5)),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _numberController,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
