// database_factory.dart
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'database_desktop.dart';
import 'database_interface.dart';
import 'database_mobile.dart';

class DatabaseFactory {
  static DatabaseInterface create() {
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not supported');
    }

    if (Platform.isIOS || Platform.isAndroid) {
      return MobileDatabaseHelper();
    } else {
      return DesktopDatabaseHelper();
    }
  }
}
