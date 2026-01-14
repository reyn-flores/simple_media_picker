import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_media_picker/src/cubit/album_picker_cubit.dart';
import 'package:simple_media_picker/src/widget/album_picker_content.dart';

class AlbumPickerPage extends StatelessWidget {
  const AlbumPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumPickerCubit(),
      child: const AlbumPickerContent(),
    );
  }
}
