import 'dart:convert';
import 'dart:developer';

import 'package:marego_app/services/tapconnect/model/station_model.dart';
import 'package:http/http.dart' as http;

class StationsAPI {
  static Future<List<Station>> getStationsAroundCoordinate(
    double latitude,
    double longitude,
  ) async {
    log('IN API CALL');
    // final url = Uri.https(apiBase, '/stop/$latitude/$longitude');
    final url = Uri.https(apiBase, '/stop/4.648306/52.423285');
    final response = await http.read(
      url,
    );

    return _parseResponse(response);
  }

  static List<Station> _parseResponse(String response) {
    final parsed = jsonDecode(response).cast<Map<String, dynamic>>();

    return parsed.map<Station>((json) => Station.fromJson(json)).toList();
  }
}

const String apiBase = 'mighty-river-90942.herokuapp.com';
