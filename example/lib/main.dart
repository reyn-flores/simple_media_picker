import 'package:flutter/material.dart';
import 'package:simple_media_picker/simple_media_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Media Picker Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<AssetEntity> _selectedMedia = [];

  Future<void> _pickMedia() async {
    final result = await MediaPicker.pickMedia(
      context,
      confirmButtonText: 'Select',
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedMedia
          ..clear()
          ..addAll(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Simple Media Picker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _pickMedia,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick Media'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          if (_selectedMedia.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No media selected',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the button above to pick media',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selected: ${_selectedMedia.length} item(s)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedMedia.clear();
                            });
                          },
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                      itemCount: _selectedMedia.length,
                      itemBuilder: (context, index) {
                        final asset = _selectedMedia[index];
                        return MediaThumbnail(
                          asset: asset,
                          onTap: () => _showMediaDetails(asset),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showMediaDetails(AssetEntity asset) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => MediaDetailsSheet(asset: asset),
    );
  }
}

class MediaThumbnail extends StatelessWidget {
  const MediaThumbnail({required this.asset, this.onTap, super.key});

  final AssetEntity asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AssetEntityImage(
            asset,
            isOriginal: false,
            thumbnailSize: const ThumbnailSize.square(200),
            fit: BoxFit.cover,
          ),
          if (asset.type == AssetType.video)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      _formatDuration(asset.videoDuration),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class MediaDetailsSheet extends StatelessWidget {
  const MediaDetailsSheet({required this.asset, super.key});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Media Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _DetailRow(
            icon: Icons.category,
            label: 'Type',
            value: asset.type.name.toUpperCase(),
          ),
          _DetailRow(
            icon: Icons.aspect_ratio,
            label: 'Dimensions',
            value: '${asset.width} x ${asset.height}',
          ),
          if (asset.type == AssetType.video)
            _DetailRow(
              icon: Icons.timer,
              label: 'Duration',
              value: _formatDuration(asset.videoDuration),
            ),
          _DetailRow(
            icon: Icons.calendar_today,
            label: 'Created',
            value: _formatDate(asset.createDateTime),
          ),
          if (asset.title != null && asset.title!.isNotEmpty)
            _DetailRow(icon: Icons.title, label: 'Title', value: asset.title!),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
