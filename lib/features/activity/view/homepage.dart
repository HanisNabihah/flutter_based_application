import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/activity_type_provider.dart';
import '../controller/history_provider.dart';
import '../model/activity_model.dart';
import 'history.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  static const activityTypes = [
    'education',
    'recreational',
    'social',
    'diy',
    'charity',
    'cooking',
    'relaxation',
    'music',
    'busywork',
  ];

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ActivityModel? currentActivity;

  Future<void> _fetchActivity() async {
    final selectedType = ref.read(activityTypeProvider);
    final url = selectedType == null || selectedType.isEmpty
        ? 'https://bored.api.lewagon.com/api/activity'
        : 'https://bored.api.lewagon.com/api/activity?type=$selectedType';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final activity = ActivityModel.fromJson(data);
        setState(() {
          currentActivity = activity;
        });
        ref.read(historyProvider.notifier).addActivity(activity);

        // Save activity history to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final historyList = ref.read(historyProvider);
        final historyJson = historyList
            .map((activity) => json.encode(activity.toJson()))
            .toList();
        await prefs.setStringList('activity_history', historyJson);
      } else {
        _showErrorSnackBar('Failed to fetch activity');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = ref.watch(activityTypeProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondaryFixedVariant,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Select activity type'),
              value: selectedType,
              items: [
                const DropdownMenuItem(value: null, child: Text('All Types')),
                ...HomePage.activityTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    )),
              ],
              onChanged: (value) {
                ref.read(activityTypeProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 20),
            if (currentActivity != null) ...[
              Text('Activity: ${currentActivity!.type}',
                  style: const TextStyle(fontSize: 16)),
              Text('Price: \$${currentActivity!.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16)),
            ] else ...[
              const Text('No activity fetched yet.',
                  style: TextStyle(fontSize: 16)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchActivity,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
