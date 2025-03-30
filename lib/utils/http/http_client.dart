import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk_app/services/log_service.dart ';

class THttpHelper {
  static const String _baseUrl = 'https://uatapi.afc-transit.com'; //UAT
  // static const String _baseUrl ='https://prodapi.afc-transit.com' //PROD

  // Helper method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final logger = LogService().logger;
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    if (kDebugMode) {
      print('url : $_baseUrl/$endpoint');
      print('response: ${response.body}');
    }
    logger.i('url : $_baseUrl/$endpoint');
    logger.i('response: ${response.body}');
    return _handleResponse(response);
  }

  // Helper method to make a POST request
  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    final logger = LogService().logger;
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (kDebugMode) {
      print('url : $_baseUrl/$endpoint');
      print('payload : $data');
      print('response: ${response.body}');
    }
    logger.i('url : $_baseUrl/$endpoint');
    logger.i('payload : $data');
    logger.i('response: ${response.body}');
    return _handleResponse(response);
  }

  // Helper method to make a PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (kDebugMode) {
      print('url : $_baseUrl/$endpoint');
      print('payload : $data');
      print('response: ${response.body}');
    }
    return _handleResponse(response);
  }

  // Helper method to make a DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));
    if (kDebugMode) {
      print(response.body);
    }
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      var res = response.body;
      if (response.body[0] == '[' || response.body[0] != '{') {
        res = '{"response": ${response.body}}';
      }

      return json.decode(res);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
