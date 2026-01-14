import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_media_picker/src/model/album.dart';

part 'album_picker_state.dart';

class AlbumPickerCubit extends Cubit<AlbumPickerState> {
  AlbumPickerCubit() : super(const AlbumPickerState()) {
    init();
  }

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));

    final permissionState = await PhotoManager.requestPermissionExtend();
    final assetPaths = await PhotoManager.getAssetPathList();

    final albums = await Future.wait(assetPaths.map(Album.fromAssetPathEntity));

    emit(
      state.copyWith(
        isLoading: false,
        albums: albums.whereType<Album>().toList(),
        permissionState: permissionState,
      ),
    );
  }
}
