//Handles API calls

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_based_application/features/activity/model/activity_model.dart';

class ActivityApi {
  static const String url = 'https://bored.api.lewagon.com/api/activity';

  Future<ActivityModel> fetchActivity(String? type) async {
    try {
      final uri = Uri.parse(url).replace(
        queryParameters:
            type != null && type.isNotEmpty ? {'type': type} : null,
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ActivityModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load activity. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching activity: $e');
    }
  }
}
