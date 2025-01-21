// database_interface.dart
import 'dart:async';

abstract class DatabaseInterface {
  Future<void> initialize();
  Future<int> insertRecord(Map<String, dynamic> record);
  Future<void> close();
}
