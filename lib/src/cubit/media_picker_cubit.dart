import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit({required AssetPathEntity assetPathEntity})
    : super(MediaPickerState(assetPathEntity: assetPathEntity)) {
    init();
  }

  static const int _pageSize = 50;
  int _currentPage = 0;
  bool _hasMoreItems = true;

  Future<void> init() async {
    await _loadNextPage(isInitial: true);
  }

  Future<void> _loadNextPage({required bool isInitial}) async {
    final isPaginationLoading = !isInitial;
    final hasAssets = state.assets.isNotEmpty;
    final canLoadMore = !_hasMoreItems || state.isPaginationLoading;

    if (isPaginationLoading && hasAssets && canLoadMore) {
      return;
    }

    emit(state.copyWith(isLoading: isInitial, isPaginationLoading: !isInitial));

    final assets = await state.assetPathEntity.getAssetListPaged(
      page: _currentPage,
      size: _pageSize,
    );

    final updatedAssets = [...state.assets, ...assets];
    _hasMoreItems = assets.length == _pageSize;
    _currentPage++;

    emit(
      state.copyWith(
        isLoading: false,
        isPaginationLoading: false,
        assets: updatedAssets,
        hasReachedMax: !_hasMoreItems,
      ),
    );
  }

  Future<void> loadMore() async {
    await _loadNextPage(isInitial: false);
  }

  void toggleSelectedAsset(String id) {
    final selectedAssets = List<String>.from(state.selectedAssets);

    if (selectedAssets.contains(id)) {
      selectedAssets.remove(id);
    } else {
      selectedAssets.add(id);
    }

    emit(state.copyWith(selectedAssets: selectedAssets));
  }
}
