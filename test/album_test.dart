import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:simple_media_picker/src/model/album.dart';

// Mock classes for testing
class MockAssetPathEntity extends AssetPathEntity {
  MockAssetPathEntity({
    required super.id,
    required super.name,
    this.mockAssetCount = 0,
    this.mockAssets = const [],
  });

  final int mockAssetCount;
  final List<AssetEntity> mockAssets;

  @override
  Future<int> get assetCountAsync async => mockAssetCount;

  @override
  Future<List<AssetEntity>> getAssetListRange({
    required int start,
    required int end,
  }) async {
    if (mockAssets.isEmpty) return [];
    return mockAssets.sublist(
      start,
      end > mockAssets.length ? mockAssets.length : end,
    );
  }
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
  group('Album', () {
    test('constructor creates album with all properties', () {
      final mockAssetPath = MockAssetPathEntity(id: '1', name: 'Test Album');
      final mockAsset = MockAssetEntity(
        id: 'asset1',
        typeInt: 1,
        width: 100,
        height: 100,
      );

      final album = Album(
        name: 'Test Album',
        assetCount: 10,
        coverAsset: mockAsset,
        assetPathEntity: mockAssetPath,
      );

      expect(album.name, equals('Test Album'));
      expect(album.assetCount, equals(10));
      expect(album.coverAsset, equals(mockAsset));
      expect(album.assetPathEntity, equals(mockAssetPath));
    });

    test('fromAssetPathEntity returns null when asset count is 0', () async {
      final mockAssetPath = MockAssetPathEntity(id: '1', name: 'Empty Album');

      final album = await Album.fromAssetPathEntity(mockAssetPath);

      expect(album, isNull);
    });

    test('fromAssetPathEntity creates album when assets exist', () async {
      final mockAsset = MockAssetEntity(
        id: 'asset1',
        typeInt: 1,
        width: 100,
        height: 100,
      );

      final mockAssetPath = MockAssetPathEntity(
        id: '1',
        name: 'My Photos',
        mockAssetCount: 5,
        mockAssets: [mockAsset],
      );

      final album = await Album.fromAssetPathEntity(mockAssetPath);

      expect(album, isNotNull);
      expect(album!.name, equals('My Photos'));
      expect(album.assetCount, equals(5));
      expect(album.coverAsset, equals(mockAsset));
      expect(album.assetPathEntity, equals(mockAssetPath));
    });
  });
}
