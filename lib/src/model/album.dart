import 'package:photo_manager/photo_manager.dart';

class Album {
  Album({
    required this.name,
    required this.assetCount,
    required this.coverAsset,
    required this.assetPathEntity,
  });

  final String name;
  final int assetCount;
  final AssetEntity coverAsset;
  final AssetPathEntity assetPathEntity;

  static Future<Album?> fromAssetPathEntity(AssetPathEntity entity) async {
    final assetCount = await entity.assetCountAsync;

    if (assetCount == 0) return null;

    final coverAsset = (await entity.getAssetListRange(start: 0, end: 1)).first;

    return Album(
      name: entity.name,
      assetCount: assetCount,
      coverAsset: coverAsset,
      assetPathEntity: entity,
    );
  }
}
