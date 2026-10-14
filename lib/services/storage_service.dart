import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../models/progress_model.dart';

/// The only place that touches SharedPreferences.
class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static const _progressKey = 'progress';
  static const _versionKey = 'storageVersion';

  ProgressState loadProgress() {
    if (_prefs.getInt(_versionKey) != AppConfig.storageVersion) {
      return const ProgressState();
    }
    final raw = _prefs.getString(_progressKey);
    if (raw == null) return const ProgressState();
    try {
      return ProgressState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt or outdated data: start fresh instead of crashing.
      return const ProgressState();
    }
  }

  Future<void> saveProgress(ProgressState state) async {
    await _prefs.setInt(_versionKey, AppConfig.storageVersion);
    await _prefs.setString(_progressKey, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    await _prefs.remove(_progressKey);
    await _prefs.remove(_versionKey);
  }

  /// Raw dump for Developer Mode.
  Map<String, Object?> debugDump() => {
    for (final k in _prefs.getKeys()) k: _prefs.get(k),
  };
}
