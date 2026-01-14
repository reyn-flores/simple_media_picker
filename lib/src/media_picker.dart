import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_media_picker/src/view/album_picker_page.dart';
import 'package:simple_media_picker/src/widget/media_picker_config.dart';

class MediaPicker {
  MediaPicker._();

  static Future<List<AssetEntity>?> pickMedia(
    BuildContext context, {
    String? confirmButtonText,
  }) async {
    final result = await Navigator.push<List<AssetEntity>>(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPickerConfig(
          confirmButtonText: confirmButtonText,
          child: const AlbumPickerPage(),
        ),
      ),
    );

    return result;
  }
}
