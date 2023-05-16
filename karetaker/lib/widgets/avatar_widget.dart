import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../utils/apis.dart';



class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String) onUpload;

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Container(
            width: 150,
            height: 150,
            color: Colors.grey,
            child: const Center(
              child: Text('No Image'),
            ),
          )
        else
          Image.network(
            widget.imageUrl!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ElevatedButton(
          onPressed: authController.isLoadingAvatar.value ? null : _upload,
          child: const Text('Upload'),
        ),
      ],
    );
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }

    authController.isLoadingAvatar.value = true;
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await Apis.client.storage.from('avatars').uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(contentType: imageFile.mimeType),
      );
      final imageUrlResponse = await Apis.client.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      widget.onUpload(imageUrlResponse);
    } on StorageException catch (error) {
      if (mounted) {
        Get.snackbar('Oops!', error.message,
            borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (error) {
      if (mounted) {
        Get.snackbar('Oops!', 'Unexpected error occurred',
            borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
    authController.isLoadingAvatar.value = false;
  }
}