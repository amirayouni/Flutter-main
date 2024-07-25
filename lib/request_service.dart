import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestService {
  final String baseUrl;

  RequestService({required this.baseUrl});

  Future<List<Request>> getAllRequests() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/demandes'));

    if (response.statusCode == 200) {
      final List<dynamic> requestList = json.decode(response.body);
      return requestList.map((json) => Request.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<Request> createRequest(Request request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/demandes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return Request.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create request');
    }
  }

  Future<Request> updateRequest(int id, Request request) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/v1/demandes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return Request.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update request');
    }
  }

  Future<void> deleteRequest(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/api/v1/demandes/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete request');
    }
  }
}

class Request {
  final int? id;
  final String title;
  final String details;
  RequestStatus status;

  Request({
    this.id,
    required this.title,
    required this.details,
    this.status = RequestStatus.pending,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      title: json['title'],
      details: json['details'],
      status: RequestStatus.values[json['status']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'status': status.index,
    };
  }
}

enum RequestStatus { pending, accepted, rejected }
