import 'package:board/models/note.dart';
import 'package:board/services/local_storage_service.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:wakelock/wakelock.dart';

class Helper {
  static Future<void> enterDisplayMode() async {
    // Enter landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    enterFullscreenMode();

    try {
      Wakelock.enable();
      Screen.setBrightness(await LocalStorageService.loadScreenBrightness());
    } on PlatformException catch (e) {
      // Waiting for wakelock to support Linux
      // https://github.com/creativecreatorormaybenot/wakelock/issues/97
      print(e.message);
    } on MissingPluginException catch (e) {
      print(e.message);
    }
  }

  static void enterFullscreenMode() {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  static Future<void> exitDisplayMode() async {
    try {
      LocalStorageService.saveScreenBrightness(await Screen.brightness);
      // Restore system screen brightness
      Screen.setBrightness(-1);
      Wakelock.disable();
    } on MissingPluginException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      // Waiting for wakelock to support Linux
      // https://github.com/creativecreatorormaybenot/wakelock/issues/97
      print(e.message);
    }

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
