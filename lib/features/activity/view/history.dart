import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/history_provider.dart';
import '../controller/activity_type_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityHistory = ref.watch(historyProvider);
    final selectedType = ref.watch(activityTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
      ),
      body: ListView.builder(
        itemCount: activityHistory.length,
        itemBuilder: (context, index) {
          final activity = activityHistory[index];

          final isSelectedType =
              selectedType != null && activity.type == selectedType;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelectedType ? Colors.lightGreenAccent : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity: ${activity.type}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Price: \$${activity.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
