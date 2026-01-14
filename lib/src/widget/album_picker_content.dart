import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_media_picker/src/cubit/album_picker_cubit.dart';
import 'package:simple_media_picker/src/widget/album_picker_item.dart';

class AlbumPickerContent extends StatelessWidget {
  const AlbumPickerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumPickerCubit, AlbumPickerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              'Albums',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
            scrolledUnderElevation: 0,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AlbumPickerState state) {
    if (state.isLoading) {
      return const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.permissionState == PermissionState.denied) {
      return const Center(
        child: Text('Permission to access photos and videos was denied.'),
      );
    }

    if (state.albums.isEmpty) {
      return const Center(child: Text('No photos or videos found.'));
    }

    return CustomScrollView(
      slivers: [
        if (state.permissionState == PermissionState.limited) ...[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Permission to access photos and videos is limited.'),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 32),
          sliver: SliverList.builder(
            itemCount: state.albums.length,
            itemBuilder: (context, index) {
              final album = state.albums[index];
              return AlbumPickerItem(album: album);
            },
          ),
        ),
      ],
    );
  }
}
