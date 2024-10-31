import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  void _storeImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onPickImage(_selectedImage!);
  }

  void _pickImage() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.camera,
                color: Theme.of(context).colorScheme.surface,
              ),
              title: Text(
                'Camera',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _storeImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo,
                color: Theme.of(context).colorScheme.surface,
              ),
              title: Text(
                'Gallery',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _storeImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Icon(
      Icons.add_a_photo_rounded,
      color: Theme.of(context).colorScheme.tertiary.withOpacity(1),
      size: 70,
    );

    if (_selectedImage != null) {
      content = ClipOval(
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(70),
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 70,
        backgroundColor:
            Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(1),
        child: content,
      ),
    );
  }
}
