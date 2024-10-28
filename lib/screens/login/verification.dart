import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/util/alert.dart';

FirebaseAuth auth = FirebaseAuth.instance;

import '../home/home.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _verificationId;

  void _verifyPhoneNumber() async {
    print('Verifying phone number ${widget.phoneNumber}');

    await auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;
        print('Received verification id: $verificationId');
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        print('Error verifying phone number: $e');
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Phone verification timed out! $verificationId');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // _verifyPhoneNumber();
  }

  void _signInWithOTP(String otp) async {
    if (_verificationId == null) {
      return;
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: otp);

      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _showFailedSigninDialog(
          e.message ?? 'Failed to authenticate phone number');
    } on Exception catch (e) {
      _showFailedSigninDialog('Failed to authenticate phone number');
    }
  }

  void _showFailedSigninDialog(String message) {
    showNotificationDalog(context: context, message: message, actions: [
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

  @override
  Widget build(BuildContext context) {
    final description = [
      TextSpan(
          text: 'Waiting to automatically detect an SMS sent to ',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
              )),
      TextSpan(
          text: '${widget.phoneNumber}. ',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                fontWeight: FontWeight.bold,
              )),
      TextSpan(
        text: 'Wrong number?',
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
          'Verifying your phone number',
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
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: _codeController,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.surface),
                        onChanged: (value) {
                          if (value.length == 6) {
                            _signInWithOTP(value);
                          }
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _verifyPhoneNumber();
                      },
                      child: const Text('Send OTP'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
