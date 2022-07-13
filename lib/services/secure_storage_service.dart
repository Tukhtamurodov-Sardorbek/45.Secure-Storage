import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum StorageKeys{
  NAME,
  BIRTHDAY,
  PETS,
}

class SecureStorage{
  static const _storage = FlutterSecureStorage();

  static String key(StorageKeys key){
    switch(key){
      case StorageKeys.NAME:
        return 'name';
      case StorageKeys.PETS:
        return 'pets';
      case StorageKeys.BIRTHDAY:
        return 'birthday';
    }
  }

  /// * String
  static Future storeString({required String key, required String data}) async{
    await _storage.write(key: key, value: data);
  }

  static Future<String?> getString({required String key}) async{
    return await _storage.read(key: key);
  }

  /// * List
  static Future storeList({required String key, required List<String> data}) async{
    final stringData = json.encode(data);
    await _storage.write(key: key, value: stringData);
  }

  static Future<List<String>?> getList({required String key}) async{
    final stringData = await _storage.read(key: key);
    return stringData == null ? null : List<String>.from(json.decode(stringData));
  }

  /// * DateTime
  static Future storeDateTime({required String key, required DateTime dt}) async{
    final date = dt.toIso8601String();
    await _storage.write(key: key, value: date);
  }

  static Future<DateTime?> getDateTime({required String key}) async{
    final date = await _storage.read(key: key);
    return date == null ? null : DateTime.tryParse(date);
  }

  /// * Delete
  static Future deleteData({required String key}) async{
    await _storage.delete(key: key);
  }

  /// * Clear
  static Future clearStorage() async{
    await _storage.deleteAll();
  }
}