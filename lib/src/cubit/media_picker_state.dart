part of 'media_picker_cubit.dart';

class MediaPickerState extends Equatable {
  const MediaPickerState({
    required this.assetPathEntity,
    this.isLoading = false,
    this.assets = const [],
    this.selectedAssets = const [],
    this.hasReachedMax = false,
    this.isPaginationLoading = false,
  });

  final AssetPathEntity assetPathEntity;
  final bool isLoading;
  final List<AssetEntity> assets;
  final List<String> selectedAssets;
  final bool hasReachedMax;
  final bool isPaginationLoading;

  @override
  List<Object?> get props => [
    isLoading,
    assets,
    selectedAssets,
    isPaginationLoading,
  ];

  MediaPickerState copyWith({
    bool? isLoading,
    List<AssetEntity>? assets,
    List<String>? selectedAssets,
    bool? hasReachedMax,
    bool? isPaginationLoading,
  }) {
    return MediaPickerState(
      assetPathEntity: assetPathEntity,
      isLoading: isLoading ?? this.isLoading,
      assets: assets != null ? List<AssetEntity>.from(assets) : this.assets,
      selectedAssets: selectedAssets != null
          ? List<String>.from(selectedAssets)
          : this.selectedAssets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
    );
  }
}
