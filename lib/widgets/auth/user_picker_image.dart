// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File? pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  final defaultImage = const AssetImage('assets/images/smile2.png');
  // File defaultImage = File('assets/images/smile.png');

  Future<void> _pickImage(bool isCamera) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(_pickedImage);
    print(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          // foregroundImage:
          //     _pickedImage == null ? FileImage(defaultImage) : null,
          backgroundImage: _pickedImage == null
              ? defaultImage as ImageProvider
              : FileImage(_pickedImage!),
          radius: 45,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              textColor: Colors.white,
              icon: const Icon(Icons.photo_camera),
              label: const Text('Add Image'),
              onPressed: () => _pickImage(true),
            ),
            FlatButton.icon(
              textColor: Colors.white,
              icon: const Icon(Icons.photo),
              label: const Text('Chose from gallery'),
              onPressed: () => _pickImage(false),
            )
          ],
        )
      ],
    );
  }
}
