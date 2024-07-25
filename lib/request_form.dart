import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestPage extends StatefulWidget {
  final bool showActionButtons;

  const RequestPage({Key? key, this.showActionButtons = true})
      : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();

  // Static method to handle navigation
  static void navigateTo(BuildContext context,
      {bool showActionButtons = true}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RequestPage(showActionButtons: showActionButtons),
      ),
    );
  }
}

class _RequestPageState extends State<RequestPage> {
  final List<Request> _requests = [];
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final String _baseUrl = 'http://192.168.1.130:8090/api/v1/demandes';
  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> requestList = json.decode(response.body);
      setState(() {
        _requests.clear();
        _requests
            .addAll(requestList.map((data) => Request.fromJson(data)).toList());
      });
    } else {
      setState(() {
        _message = 'Failed to load requests';
      });
    }
  }

  Future<void> _addRequest() async {
    final title = _titleController.text;
    final details = _detailsController.text;

    if (title.isNotEmpty && details.isNotEmpty) {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'type': title, // Map title to type
          'details': details,
          'status': 'pending' // Ensure status is pending by default
        }),
      );

      if (response.statusCode == 201) {
        final newRequest = Request.fromJson(json.decode(response.body));
        setState(() {
          _requests.add(newRequest);
          _message = 'Request added successfully';
        });
        _titleController.clear();
        _detailsController.clear();
      } else {
        setState(() {
          _message =
              'Failed to add request: ${response.statusCode} ${response.body}';
        });
      }
    } else {
      setState(() {
        _message = 'Title and details are required';
      });
    }
  }

  Future<void> _updateRequestStatus(int index, RequestStatus status) async {
    final request = _requests[index];
    final response = await http.put(
      Uri.parse('$_baseUrl/${request.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': request.title, // Map title to type
        'details': request.details,
        'status': status.toString().split('.').last,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _requests[index].status = status;
        _message = 'Request updated successfully';
      });
    } else {
      setState(() {
        _message =
            'Failed to update request: ${response.statusCode} ${response.body}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Management'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title, color: Colors.orange),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _detailsController,
                    decoration: InputDecoration(
                      labelText: 'Details',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.details, color: Colors.orange),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addRequest,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _requests.length,
                itemBuilder: (context, index) {
                  final request = _requests[index];
                  Color backgroundColor;
                  TextDecoration textDecoration;
                  if (request.status == RequestStatus.accepted) {
                    backgroundColor = Colors.green.shade50;
                    textDecoration = TextDecoration.none;
                  } else if (request.status == RequestStatus.rejected) {
                    backgroundColor = Colors.red.shade50;
                    textDecoration = TextDecoration.lineThrough;
                  } else {
                    backgroundColor = Colors.transparent;
                    textDecoration = TextDecoration.none;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            request.title ?? 'No title',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: request.status == RequestStatus.rejected
                                  ? Colors.red
                                  : Colors.black,
                              decoration: textDecoration,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Status: ${request.status.toString().split('.').last}',
                            style: TextStyle(
                              fontSize: 14,
                              color: request.status == RequestStatus.rejected
                                  ? Colors.red
                                  : Colors.black,
                              decoration: textDecoration,
                            ),
                          ),
                        ),
                        if (widget.showActionButtons &&
                            request.status == RequestStatus.pending)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () => _updateRequestStatus(
                                    index, RequestStatus.accepted),
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => _updateRequestStatus(
                                    index, RequestStatus.rejected),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _message,
                  style: TextStyle(
                      color: _message.contains('Failed')
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum RequestStatus { pending, accepted, rejected }

class Request {
  final int id;
  final String? title;
  final String? details;
  RequestStatus status;

  Request({
    required this.id,
    this.title,
    this.details,
    this.status = RequestStatus.pending,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      title: json['type'] ?? 'No title', // Map type to title
      details: json['details'] ?? 'No details',
      status: RequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => RequestStatus.pending, // Fallback to pending if no match
      ),
    );
  }
}
