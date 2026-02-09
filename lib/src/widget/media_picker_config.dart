import 'package:flutter/material.dart';

class MediaPickerConfig extends InheritedWidget {
  const MediaPickerConfig({
    required super.child,
    this.confirmButtonText,
    this.allowMultiple = true,
    super.key,
  });

  final String? confirmButtonText;
  final bool allowMultiple;

  static MediaPickerConfig? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MediaPickerConfig>();
  }

  static MediaPickerConfig of(BuildContext context) {
    final config = maybeOf(context);
    assert(config != null, 'No MediaPickerConfig found in context');
    return config!;
  }

  @override
  bool updateShouldNotify(MediaPickerConfig oldWidget) {
    return confirmButtonText != oldWidget.confirmButtonText ||
        allowMultiple != oldWidget.allowMultiple;
  }
}
