//History Management
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/activity_model.dart';

class HistoryNotifier extends StateNotifier<List<ActivityModel>> {
  HistoryNotifier() : super([]);

  void addActivity(ActivityModel activity) {
    state = [activity, ...state].take(50).toList(); // Max 50 entries
    _saveToPrefs();
  }

  void loadFromPrefs(List<ActivityModel> history) {
    state = history;
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = state.map((a) => json.encode(a.toJson())).toList();
    await prefs.setStringList('activity_history', historyJson);
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<ActivityModel>>((ref) {
  return HistoryNotifier();
});
