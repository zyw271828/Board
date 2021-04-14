import 'package:board/models/note.dart';
import 'package:flutter/services.dart';

class Helper {
  static void enterDisplayMode() {
    // Enter landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    enterFullscreenMode();
  }

  static void enterFullscreenMode() {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  static void exitDisplayMode() {
    exitFullscreenMode();

    // Enter portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  static void exitFullscreenMode() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  static int generateDarkThemeId(int lightThemeId) {
    return isLightTheme(lightThemeId) ? (lightThemeId + 100) : null;
  }

  static int generateLightThemeId(int darkThemeId) {
    return isDarkTheme(darkThemeId) ? (darkThemeId - 100) : null;
  }

  static bool isDarkTheme(int themeId) {
    return !isLightTheme(themeId);
  }

  static bool isLightTheme(int themeId) {
    return themeId < 100;
  }

  static void updateColorCodes(List<Note> notes) {
    const int maxColorCode = 900;
    const int minColorCode = 300;
    const int step = 100;

    int curColorCode = maxColorCode;
    bool isColorCodesIncreasing = false;

    for (var note in notes) {
      if (isColorCodesIncreasing) {
        note.colorCode = curColorCode;
        curColorCode += step;
        if (curColorCode >= maxColorCode) {
          isColorCodesIncreasing = false;
        }
      } else {
        note.colorCode = curColorCode;
        curColorCode -= step;
        if (curColorCode <= minColorCode) {
          isColorCodesIncreasing = true;
        }
      }
    }
  }
}
