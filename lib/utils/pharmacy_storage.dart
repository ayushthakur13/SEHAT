import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyStorage {
  static const String _favoritesKey = 'pharmacy_favorite_medicines';
  static const String _notifyKey = 'pharmacy_notify_medicines';
  static const String _reservationsKey = 'pharmacy_reservations';

  static Future<Set<String>> _getSet(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(key) ?? const <String>[]).toSet();
  }

  static Future<void> _saveSet(String key, Set<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values.toList());
  }

  static Future<Set<String>> getFavorites() => _getSet(_favoritesKey);
  static Future<void> toggleFavorite(String medicineId) async {
    final set = await getFavorites();
    if (set.contains(medicineId)) {
      set.remove(medicineId);
    } else {
      set.add(medicineId);
    }
    await _saveSet(_favoritesKey, set);
  }

  static Future<Set<String>> getNotifyList() => _getSet(_notifyKey);
  static Future<void> toggleNotify(String medicineId) async {
    final set = await getNotifyList();
    if (set.contains(medicineId)) {
      set.remove(medicineId);
    } else {
      set.add(medicineId);
    }
    await _saveSet(_notifyKey, set);
  }

  static Future<List<Map<String, dynamic>>> getReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_reservationsKey) ?? const <String>[];
    return raw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> addReservation(Map<String, dynamic> reservation) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_reservationsKey) ?? <String>[];
    raw.add(jsonEncode(reservation));
    await prefs.setStringList(_reservationsKey, raw);
  }
}


