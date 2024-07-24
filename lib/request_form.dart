import 'package:flutter/material.dart';

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

  void _addRequest() {
    final title = _titleController.text;
    final details = _detailsController.text;

    if (title.isNotEmpty && details.isNotEmpty) {
      setState(() {
        _requests.add(Request(title: title, details: details));
      });
      _titleController.clear();
      _detailsController.clear();
    }
  }

  void _updateRequestStatus(int index, RequestStatus status) {
    setState(() {
      _requests[index].status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _detailsController,
                  decoration: InputDecoration(labelText: 'Details'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addRequest,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final request = _requests[index];
                Color backgroundColor;
                TextDecoration textDecoration;
                if (request.status == RequestStatus.accepted) {
                  backgroundColor = Colors.green.shade100;
                  textDecoration = TextDecoration.none;
                } else if (request.status == RequestStatus.rejected) {
                  backgroundColor = Colors.red.shade100;
                  textDecoration = TextDecoration.lineThrough;
                } else {
                  backgroundColor = Colors.transparent;
                  textDecoration = TextDecoration.none;
                }

                return Container(
                  color: backgroundColor,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          request.title,
                          style: TextStyle(
                            color: request.status == RequestStatus.rejected
                                ? Colors.red
                                : Colors.black,
                            decoration: textDecoration,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          request.details,
                          style: TextStyle(
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
        ],
      ),
    );
  }
}

enum RequestStatus { pending, accepted, rejected }

class Request {
  final String title;
  final String details;
  RequestStatus status;

  Request({
    required this.title,
    required this.details,
    this.status = RequestStatus.pending,
  });
}
