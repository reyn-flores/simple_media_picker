import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:simple_media_picker/src/widget/media_picker_content.dart';

// Mock classes
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

class MockMediaPickerCubit extends Cubit<MediaPickerState>
    implements MediaPickerCubit {
  MockMediaPickerCubit(super.initialState);

  @override
  void toggleSelectedAsset(String id) {
    final selectedAssets = List<String>.from(state.selectedAssets);
    if (selectedAssets.contains(id)) {
      selectedAssets.remove(id);
    } else {
      selectedAssets.add(id);
    }
    emit(state.copyWith(selectedAssets: selectedAssets));
  }

  @override
  Future<void> loadMore() async {}

  @override
  Future<void> init() async {}
}

void main() {
  group('MediaPickerContent', () {
    late MockMediaPickerCubit mockCubit;
    late MockAssetPathEntity mockAssetPath;

    setUp(() {
      mockAssetPath = MockAssetPathEntity(id: '1', name: 'Camera Roll');
    });

    Widget buildTestWidget(
      MediaPickerState state, {
      String? confirmButtonText,
    }) {
      mockCubit = MockMediaPickerCubit(state);
      return MaterialApp(
        home: BlocProvider<MediaPickerCubit>.value(
          value: mockCubit,
          child: MediaPickerContent(confirmButtonText: confirmButtonText),
        ),
      );
    }

    testWidgets('displays album name in app bar', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(MediaPickerState(assetPathEntity: mockAssetPath)),
      );

      expect(find.text('Camera Roll'), findsOneWidget);
    });

    testWidgets('displays back arrow icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(MediaPickerState(assetPathEntity: mockAssetPath)),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays default Done button text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(MediaPickerState(assetPathEntity: mockAssetPath)),
      );

      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('displays custom confirm button text', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          MediaPickerState(assetPathEntity: mockAssetPath),
          confirmButtonText: 'Upload',
        ),
      );

      expect(find.text('Upload'), findsOneWidget);
    });

    testWidgets('Done button is disabled when no assets selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(MediaPickerState(assetPathEntity: mockAssetPath)),
      );

      final textButton = tester.widget<TextButton>(find.byType(TextButton));
      expect(textButton.onPressed, isNull);
    });

    testWidgets('displays loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          MediaPickerState(assetPathEntity: mockAssetPath, isLoading: true),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty state when no assets', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(MediaPickerState(assetPathEntity: mockAssetPath)),
      );

      expect(find.text('No photos or videos found.'), findsOneWidget);
    });
  });
}
