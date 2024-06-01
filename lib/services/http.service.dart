import 'dart:convert';

import 'package:http/http.dart' as http;

class Request {
  // static const urlBase = 'https://api.zefaaf.net/v1/mobile/';
  static const urlBase = 'https://zefaafapi.com/v1/mobile/';

  final String? apiToken;

  Request({this.apiToken});

  Future<http.Response> post(endPoint, body) async {
    http.Response response = await http.post(
      Uri.parse(urlBase + endPoint),
      body: body,
      headers: {'Authorization': 'Bearer $apiToken'},
    );
    return response;
  }

  Future<dynamic> get(endPoint, {String? params}) async {
    http.Response response = await http.get(
      Uri.parse(urlBase + endPoint + (params != null ? ('/$params') : "")),
      headers: {'Authorization': 'Bearer $apiToken'},
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        return result;
      } else {
        throw Exception('Failed to load data'); // statues is error
      }
    } else {
      throw Exception('Failed to load data');
    } //statues code is not 200
  }
}
