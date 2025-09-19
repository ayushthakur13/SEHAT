import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _prescriptionsKey = 'offline_prescriptions';

  static Future<List<Map<String, dynamic>>> getPrescriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prescriptionsKey) ?? [];
    return raw
        .map((s) => jsonDecode(s) as Map<String, dynamic>)
        .toList(growable: true);
  }

  static Future<void> savePrescription(Map<String, dynamic> prescription) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_prescriptionsKey) ?? [];
    existing.add(jsonEncode(prescription));
    await prefs.setStringList(_prescriptionsKey, existing);
  }

  static Future<void> clearPrescriptions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prescriptionsKey);
  }
}


