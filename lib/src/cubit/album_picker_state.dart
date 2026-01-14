part of 'album_picker_cubit.dart';

class AlbumPickerState extends Equatable {
  const AlbumPickerState({
    this.isLoading = false,
    this.albums = const [],
    this.permissionState = PermissionState.notDetermined,
  });

  final bool isLoading;
  final List<Album> albums;
  final PermissionState permissionState;

  @override
  List<Object> get props => [isLoading, albums, permissionState];

  AlbumPickerState copyWith({
    bool? isLoading,
    List<Album>? albums,
    PermissionState? permissionState,
  }) {
    return AlbumPickerState(
      isLoading: isLoading ?? this.isLoading,
      albums: albums != null ? List<Album>.from(albums) : this.albums,
      permissionState: permissionState ?? this.permissionState,
    );
  }
}
