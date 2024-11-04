import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:whatsapp_clone/util/alert.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? _verificationId;
  bool _isSending = true;

  final _cooldownSeconds = 10;
  Timer? _timer;
  int _seconds = 0;
  bool _isCountingDown = true;

  Future<void> _verifyPhoneNumber() async {
    print('Verifying phone number ${widget.phoneNumber}');
    setState(() {
      _isSending = true;
    });
    _startTimer(_cooldownSeconds);

    // TODO! Only test phone numbers are working
    // Look into the error messages when attempting to send verification SMSs
    // Perhaps recreate firebase project and don't enable AppCheck
    await auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInWithCredential(credential);
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          _verificationId = verificationId;
          _isSending = false;
        });
        print('Received verification id: $verificationId');
      },
      verificationFailed: (FirebaseAuthException e) {
        _showFailedSigninDialog('Error verifying phone number: ${e.message}');
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Phone verification timed out! $verificationId');
      },
    );

    print('Verified phone number ${widget.phoneNumber}');
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await auth.signInWithCredential(credential);
      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
    } on FirebaseAuthException catch (e) {
      _showFailedSigninDialog(
          e.message ?? 'Failed to authenticate phone number');
    } on Exception catch (e) {
      _showFailedSigninDialog('Failed to authenticate phone number');
    }
  }

  void _signInWithOTP(String otp) {
    print('Signing in with OTP: $otp');
    setState(() {
      _isSending = true;
    });
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: otp);
    _signInWithCredential(credential);
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

  void _startTimer(int start) {
    setState(() {
      _seconds = start;
      _isCountingDown = true;
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_seconds == 0) {
          setState(() {
            timer.cancel();
            _isCountingDown = false;
          });
        } else {
          setState(() {
            _seconds--;
          });
        }
      },
    );
  }

  String _formatTimer(int seconds) {
    // Duration.toString(): 0:05:00.000000
    return seconds != 0
        ? Duration(seconds: seconds).toString().substring(2, 7)
        : '';
  }

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
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
                      width: 300,
                      child: _isSending
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 31),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : PinCodeTextField(
                              appContext: context,
                              length: 6,
                              keyboardType: TextInputType.number,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(0.85),
                                  ),
                              pinTheme: PinTheme(
                                activeColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8),
                                inactiveColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              onCompleted: (value) {
                                _signInWithOTP(value);
                              },
                            ),
                    ),
                    Text(
                      'Enter 6-digit code',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.85)),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    ListTile(
                      leading: Icon(Icons.message,
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.85)),
                      title: Text(
                        'Resend SMS',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.85)),
                      ),
                      trailing: Text(_formatTimer(_seconds),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(0.85),
                                  )),
                      onTap: !_isCountingDown ? _verifyPhoneNumber : null,
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
