import 'dart:convert';

import 'package:pet_feeder/models/feeding.dart';
import 'package:http/http.dart' as http;

import '../values.dart';

class FeedingApi {

  final Uri _feedingUrl = Uri.parse(GlobalValues.baseUrl + "/feedings");

  Future<List<Feeding>> getFeedings() async {
    final response = await http.get(_feedingUrl);
    final body = json.decode(response.body);

    return List<Feeding>.from(body.map((model) => Feeding.fromJson(model)));
  }

  Future<Feeding?> saveFeeding(Feeding feeding) async {
    final response = await http.post(
      _feedingUrl,
      body: json.encode(feeding.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Feeding.fromJson(body);
    }
    throw Exception(
        "Failed to save feeding. Status code: ${response.statusCode}");
  }

  Future<void> startFeeding(int? id) async {
    if (id != null) {
      http.post(Uri.parse(GlobalValues.baseUrl + "/feedings/$id/start"));
    }
  }
}
