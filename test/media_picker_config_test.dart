import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_media_picker/src/widget/media_picker_config.dart';

void main() {
  group('MediaPickerConfig', () {
    testWidgets('provides config to descendants', (tester) async {
      String? capturedText;

      await tester.pumpWidget(
        MediaPickerConfig(
          confirmButtonText: 'Upload',
          child: Builder(
            builder: (context) {
              capturedText = MediaPickerConfig.of(context).confirmButtonText;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedText, equals('Upload'));
    });

    testWidgets('maybeOf returns null when not in tree', (tester) async {
      MediaPickerConfig? capturedConfig;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            capturedConfig = MediaPickerConfig.maybeOf(context);
            return const SizedBox();
          },
        ),
      );

      expect(capturedConfig, isNull);
    });

    testWidgets('maybeOf returns config when in tree', (tester) async {
      MediaPickerConfig? capturedConfig;

      await tester.pumpWidget(
        MediaPickerConfig(
          confirmButtonText: 'Select',
          child: Builder(
            builder: (context) {
              capturedConfig = MediaPickerConfig.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedConfig, isNotNull);
      expect(capturedConfig!.confirmButtonText, equals('Select'));
    });

    testWidgets('uses default value when confirmButtonText is null', (
      tester,
    ) async {
      String? capturedText;

      await tester.pumpWidget(
        MediaPickerConfig(
          child: Builder(
            builder: (context) {
              capturedText = MediaPickerConfig.of(context).confirmButtonText;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedText, isNull);
    });

    testWidgets('updateShouldNotify returns true when text changes', (
      tester,
    ) async {
      const oldConfig = MediaPickerConfig(
        confirmButtonText: 'Done',
        child: SizedBox(),
      );
      const newConfig = MediaPickerConfig(
        confirmButtonText: 'Upload',
        child: SizedBox(),
      );

      expect(newConfig.updateShouldNotify(oldConfig), isTrue);
    });

    testWidgets('updateShouldNotify returns false when text is same', (
      tester,
    ) async {
      const oldConfig = MediaPickerConfig(
        confirmButtonText: 'Done',
        child: SizedBox(),
      );
      const newConfig = MediaPickerConfig(
        confirmButtonText: 'Done',
        child: SizedBox(),
      );

      expect(newConfig.updateShouldNotify(oldConfig), isFalse);
    });

    testWidgets('of throws assertion when not in tree', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(() => MediaPickerConfig.of(context), throwsAssertionError);
            return const SizedBox();
          },
        ),
      );
    });
  });
}
