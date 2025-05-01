// lib/widgets/image_picker_avatar.dart

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerAvatar extends StatefulWidget {
  final String? base64Image;
  final void Function(File file, String base64) onImageSelected;

  const ImagePickerAvatar({
    super.key,
    this.base64Image,
    required this.onImageSelected,
  });

  @override
  State<ImagePickerAvatar> createState() => _ImagePickerAvatarState();
}

class _ImagePickerAvatarState extends State<ImagePickerAvatar> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 75);
    if (picked != null) {
      final file = File(picked.path);
      final base64 = base64Encode(await file.readAsBytes());
      setState(() => _imageFile = file);
      widget.onImageSelected(file, base64);
    }
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tirar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = _imageFile != null
        ? FileImage(_imageFile!)
        : (widget.base64Image != null && widget.base64Image!.isNotEmpty
            ? MemoryImage(base64Decode(widget.base64Image!))
            : null);

    return GestureDetector(
      onTap: _showOptions,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: image as ImageProvider?,
        child: image == null ? const Icon(Icons.person, size: 50) : null,
      ),
    );
  }
}
