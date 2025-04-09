//Fetching and Filtering

import 'package:flutter_based_application/features/activity/model/activity_model.dart';
import 'package:flutter_based_application/features/activity/service/activity_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity_type_provider.dart';
import 'history_provider.dart';

final activityProvider = FutureProvider<ActivityModel>((ref) async {
  final type = ref.watch(activityTypeProvider);
  final api = ActivityApi();
  final activity = await api.fetchActivity(type);

  ref.read(historyProvider.notifier).addActivity(activity);

  return activity;
});
