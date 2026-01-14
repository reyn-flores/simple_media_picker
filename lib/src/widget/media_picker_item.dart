import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:simple_media_picker/src/cubit/media_picker_cubit.dart';

class MediaPickerItem extends StatelessWidget {
  const MediaPickerItem({required this.asset, required this.state, super.key});

  final AssetEntity asset;
  final MediaPickerState state;

  MediaPickerCubit _cubit(BuildContext context) =>
      context.read<MediaPickerCubit>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _cubit(context).toggleSelectedAsset(asset.id);
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AssetEntityImage(asset, fit: BoxFit.cover),
            ),
          ),
          if (asset.type == AssetType.video) ...[
            const Positioned(
              top: 4,
              right: 4,
              child: Icon(Icons.play_circle_outline, color: Colors.white),
            ),
          ],
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: 28,
              width: 28,
              child: Checkbox(
                value: state.selectedAssets.contains(asset.id),
                onChanged: (value) {
                  _cubit(context).toggleSelectedAsset(asset.id);
                },
                shape: const CircleBorder(),
                side: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
