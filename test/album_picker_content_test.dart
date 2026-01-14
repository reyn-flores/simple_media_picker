import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_media_picker/src/cubit/album_picker_cubit.dart';
import 'package:simple_media_picker/src/model/album.dart';
import 'package:simple_media_picker/src/widget/album_picker_content.dart';

// Mock Cubit for testing
class MockAlbumPickerCubit extends Cubit<AlbumPickerState>
    implements AlbumPickerCubit {
  MockAlbumPickerCubit(super.initialState);

  @override
  Future<void> init() async {}
}

class MockAssetPathEntity extends AssetPathEntity {
  MockAssetPathEntity({required super.id, required super.name});
}

class MockAssetEntity extends AssetEntity {
  MockAssetEntity({
    required super.id,
    required super.typeInt,
    required super.width,
    required super.height,
  });
}

void main() {
  group('AlbumPickerContent', () {
    late MockAlbumPickerCubit mockCubit;

    Widget buildTestWidget(AlbumPickerState state) {
      mockCubit = MockAlbumPickerCubit(state);
      return MaterialApp(
        home: BlocProvider<AlbumPickerCubit>.value(
          value: mockCubit,
          child: const AlbumPickerContent(),
        ),
      );
    }

    testWidgets('displays Albums title in app bar', (tester) async {
      await tester.pumpWidget(buildTestWidget(const AlbumPickerState()));

      expect(find.text('Albums'), findsOneWidget);
    });

    testWidgets('displays close icon in app bar', (tester) async {
      await tester.pumpWidget(buildTestWidget(const AlbumPickerState()));

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('displays loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(const AlbumPickerState(isLoading: true)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays permission denied message', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AlbumPickerState(permissionState: PermissionState.denied),
        ),
      );

      expect(
        find.text('Permission to access photos and videos was denied.'),
        findsOneWidget,
      );
    });

    testWidgets('displays empty state when no albums', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const AlbumPickerState(permissionState: PermissionState.authorized),
        ),
      );

      expect(find.text('No photos or videos found.'), findsOneWidget);
    });

    testWidgets(
      'displays limited permission message when permission is limited',
      (tester) async {
        final mockAsset = MockAssetEntity(
          id: 'asset1',
          typeInt: 1,
          width: 100,
          height: 100,
        );
        final mockAlbum = Album(
          name: 'Test Album',
          assetCount: 5,
          coverAsset: mockAsset,
          assetPathEntity: MockAssetPathEntity(id: '1', name: 'Test Album'),
        );

        await tester.pumpWidget(
          buildTestWidget(
            AlbumPickerState(
              permissionState: PermissionState.limited,
              albums: [mockAlbum],
            ),
          ),
        );

        // Use pumpAndSettle to ensure all frames are rendered
        await tester.pumpAndSettle();

        expect(
          find.text('Permission to access photos and videos is limited.'),
          findsOneWidget,
        );
      },
    );
  });
}
