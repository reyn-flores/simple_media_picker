import 'package:flutter_test/flutter_test.dart';
import 'package:simple_media_picker/simple_media_picker.dart';

void main() {
  group('MediaPicker', () {
    test('pickMedia is a callable function', () {
      expect(MediaPicker.pickMedia, isA<Function>());
    });
  });
}
