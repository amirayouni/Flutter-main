import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.1.130:8080';

  Future<http.Response> signup(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> login(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> submitRequest(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/requests'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> fetchRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl/requests'),
    );
    return response;
  }

  Future<http.Response> acceptRequest(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/requests/$id/accept'),
    );
    return response;
  }

  Future<http.Response> rejectRequest(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/requests/$id/reject'),
    );
    return response;
  }
}
