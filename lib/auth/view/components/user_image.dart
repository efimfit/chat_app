import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  final Function pickImage;

  const UserImage(
    this.pickImage, {
    super.key,
  });

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _pickedImage;

  void _showPreviewImage() async {
    final picker = ImagePicker();
    final imageXFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
    );
    if (imageXFile == null) {
      return;
    }
    final imageFile = File(imageXFile.path);
    setState(() {
      _pickedImage = imageFile;
    });
    widget.pickImage(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _showPreviewImage,
          icon: const Icon(Icons.image),
          label: const Text('Add image'),
        ),
      ],
    );
  }
}
