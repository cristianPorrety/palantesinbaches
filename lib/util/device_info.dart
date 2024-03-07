import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoManager {
  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  static String getDeviceFamily() {
    if (Platform.isIOS) {
      return "IPHONE"; // unique ID on iOS
    } else if (Platform.isAndroid) {
      return "Android";
    } else {
      return "UNKNOWN";
    }
  }
}
