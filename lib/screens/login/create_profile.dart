import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/util/alert.dart';
import 'package:whatsapp_clone/widgets/login/image_input.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  File? _selectedImage;
  bool _isSubmitting = false;

  void _submit() async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        log('Creating user `$_name`');
        final user = FirebaseAuth.instance.currentUser;
        String? imageUrl;
        if (_selectedImage != null) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child('${user!.uid}.jpg');

          await storageRef.putFile(_selectedImage!);
          imageUrl = await storageRef.getDownloadURL();
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'username': _name,
          'phone_number': user.phoneNumber,
          'image_url': imageUrl,
        });

        await user.updatePhotoURL(imageUrl);
        await user.updateDisplayName(_name);
        // user.reload; // TODO Remove and check is userChanges() still works
        log('User `$_name` created');
        setState(() {
          _isSubmitting = false;
        });
      }
    } catch (e) {
      showNotificationDalog(
        context: context,
        message: 'Failed to create user',
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
        ],
      );
      print('Failed to create user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Profile info',
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
      backgroundColor:
          Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.7),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 32,
          bottom: 4,
          left: 24,
          right: 24,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please provide your name and an optional profile photo',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.85),
                        ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ImageInput(
                    onPickImage: (image) {
                      _selectedImage = image;
                    },
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            maxLength: 25,
                            autofocus: true,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(0.85),
                                    ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _name = newValue;
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(
                          left: 0,
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.emoji_emotions_outlined,
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.7)),
                      )
                    ],
                  )
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
                  onPressed: !_isSubmitting ? _submit : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !_isSubmitting
                          ? Text(
                              'Finish',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                  ),
                            )
                          : const CircularProgressIndicator(),
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
