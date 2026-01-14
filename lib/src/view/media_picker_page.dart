import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:simple_media_picker/src/widget/media_picker_content.dart';

class MediaPickerPage extends StatelessWidget {
  const MediaPickerPage({
    required this.assetPathEntity,
    this.confirmButtonText,
    super.key,
  });

  final AssetPathEntity assetPathEntity;
  final String? confirmButtonText;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaPickerCubit(assetPathEntity: assetPathEntity),
      child: MediaPickerContent(confirmButtonText: confirmButtonText),
    );
  }
}
