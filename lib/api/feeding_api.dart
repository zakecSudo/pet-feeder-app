import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_feeder/models/feeding.dart';

import '../values.dart';

class FeedingApi {
  final Uri _feedingUrl = Uri.parse(GlobalValues.baseUrl + "/feedings");

  Future<List<Feeding>> getAll() async {
    final response = await http.get(_feedingUrl);
    final body = json.decode(response.body);

    return List<Feeding>.from(body.map((model) => Feeding.fromJson(model)));
  }

  Future<Feeding?> create(Feeding feeding) async {
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
    throw Exception("Failed to create feeding. Status code: ${response.statusCode}");
  }

  Future<Feeding?> update(Feeding? feeding) async {
    if (feeding != null) {
      final response = await http.put(
        Uri.parse(GlobalValues.baseUrl + "/feedings/${feeding.id}"),
        body: json.encode(feeding.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return Feeding.fromJson(body);
      }
      throw Exception("Failed to update feeding. Status code: ${response.statusCode}");
    }
    return null;
  }

  Future<void> delete(int? feedingId) async {
    if (feedingId != null) {
      final response = await http.delete(Uri.parse(GlobalValues.baseUrl + "/feedings/$feedingId"));

      if (response.statusCode != 200) {
        throw Exception("Failed to delete feeding. Status code: ${response.statusCode}");
      }
    }
  }

  Future<void> startFeeding(int? id) async {
    if (id != null) {
      http.post(Uri.parse(GlobalValues.baseUrl + "/feedings/$id/start"));
    }
  }
}
