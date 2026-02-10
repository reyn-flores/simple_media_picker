import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:simple_media_picker/src/model/album.dart';
import 'package:simple_media_picker/src/view/media_picker_page.dart';
import 'package:simple_media_picker/src/widget/media_picker_config.dart';

class AlbumPickerItem extends StatelessWidget {
  const AlbumPickerItem({required this.album, super.key});

  final Album album;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 48,
          width: 48,
          child: AssetEntityImage(
            album.coverAsset,
            fit: BoxFit.cover,
            isOriginal: false,
            // Use smaller thumbnails for grid
            thumbnailSize: const ThumbnailSize.square(100),
            // Handle corrupted/unsupported files gracefully
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey,
                ),
              );
            },
            // Show placeholder while loading
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }
              return Container(color: Colors.grey[200]);
            },
          ),
        ),
      ),
      title: Text(album.name),
      subtitle: Text('${album.assetCount}'),
      onTap: () async {
        final config = MediaPickerConfig.of(context);
        final result = await Navigator.push(
          context,
          MaterialPageRoute<List<AssetEntity>>(
            builder: (_) => MediaPickerPage(
              assetPathEntity: album.assetPathEntity,
              confirmButtonText: config.confirmButtonText,
              allowMultiple: config.allowMultiple,
            ),
          ),
        );
        if (result != null && result.isNotEmpty) {
          if (context.mounted) Navigator.pop(context, result);
        }
      },
    );
  }
}
