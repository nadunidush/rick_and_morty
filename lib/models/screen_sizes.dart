import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

/// Helper function to determine the current screen type based on width.
ScreenType getScreenType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) {
    return ScreenType.mobile;
  } else if (width < 1000) {
    return ScreenType.tablet;
  } else {
    return ScreenType.desktop;
  }
}