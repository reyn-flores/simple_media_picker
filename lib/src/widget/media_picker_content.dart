import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:simple_media_picker/src/widget/media_picker_item.dart';

class MediaPickerContent extends StatelessWidget {
  const MediaPickerContent({super.key, this.confirmButtonText});

  final String? confirmButtonText;

  MediaPickerCubit _cubit(BuildContext context) =>
      context.read<MediaPickerCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              state.assetPathEntity.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              TextButton(
                onPressed: state.selectedAssets.isEmpty
                    ? null
                    : () {
                        Navigator.pop(
                          context,
                          state.assets
                              .where(
                                (asset) =>
                                    state.selectedAssets.contains(asset.id),
                              )
                              .toList(),
                        );
                      },
                child: Text(confirmButtonText ?? 'Done'),
              ),
            ],
            scrolledUnderElevation: 0,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, MediaPickerState state) {
    if (state.isLoading) {
      return const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.assets.isEmpty) {
      return const Center(child: Text('No photos or videos found.'));
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
          sliver: SliverGrid.builder(
            itemCount: state.assets.length + (state.hasReachedMax ? 0 : 1),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index >= state.assets.length) {
                _cubit(context).loadMore();
                return const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return MediaPickerItem(asset: state.assets[index], state: state);
            },
          ),
        ),
      ],
    );
  }
}
