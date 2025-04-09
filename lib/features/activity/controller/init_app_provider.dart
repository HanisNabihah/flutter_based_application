import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import '../model/activity_model.dart';
import 'activity_type_provider.dart';
import 'history_provider.dart';
import 'storage_provider.dart';

final initAppProvider = FutureProvider<void>((ref) async {
  final prefs = ref.read(sharedPrefsProvider);

  final savedType = prefs.getString('selected_type');
  if (savedType != null) {
    ref.read(activityTypeProvider.notifier).state = savedType;
  }

  final historyList = prefs.getStringList('activity_history') ?? [];
  final history = historyList.map((jsonStr) {
    final jsonData = json.decode(jsonStr);
    return ActivityModel.fromJson(jsonData);
  }).toList();

  ref.read(historyProvider.notifier).loadFromPrefs(history);

  ref.onDispose(() async {
    final type = ref.read(activityTypeProvider);
    await prefs.setString('selected_type', type ?? '');
  });
});
