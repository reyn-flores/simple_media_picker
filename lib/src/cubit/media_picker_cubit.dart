import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

part 'media_picker_state.dart';

class MediaPickerCubit extends Cubit<MediaPickerState> {
  MediaPickerCubit({
    required AssetPathEntity assetPathEntity,
    this.allowMultiple = true,
  }) : super(MediaPickerState(assetPathEntity: assetPathEntity)) {
    init();
  }

  static const int _pageSize = 50;
  int _currentPage = 0;
  bool _hasMoreItems = true;
  bool _isLoadingPage = false; // Lock to prevent concurrent loads
  final bool allowMultiple;

  Future<void> init() async {
    await _loadNextPage(isInitial: true);
  }

  Future<void> _loadNextPage({required bool isInitial}) async {
    // Prevent concurrent page loads - this is the critical fix
    if (_isLoadingPage) return;
    if (!isInitial && !_hasMoreItems) return;

    _isLoadingPage = true;

    try {
      if (isClosed) return;
      emit(
        state.copyWith(isLoading: isInitial, isPaginationLoading: !isInitial),
      );

      final assets = await state.assetPathEntity.getAssetListPaged(
        page: _currentPage,
        size: _pageSize,
      );

      if (isClosed) return;

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
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, isPaginationLoading: false));
    } finally {
      _isLoadingPage = false;
    }
  }

  Future<void> loadMore() async {
    await _loadNextPage(isInitial: false);
  }

  void toggleSelectedAsset(String id) {
    if (isClosed) return;

    final selectedAssets = List<String>.from(state.selectedAssets);

    if (selectedAssets.contains(id)) {
      selectedAssets.remove(id);
    } else {
      if (allowMultiple) {
        selectedAssets.add(id);
      } else {
        selectedAssets
          ..clear()
          ..add(id);
      }
    }

    emit(state.copyWith(selectedAssets: selectedAssets));
  }
}
