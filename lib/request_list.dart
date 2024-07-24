import 'package:flutter/material.dart';

class RequestList extends StatelessWidget {
  final List<Map<String, String>> requests;

  RequestList(this.requests);

  @override
  Widget build(BuildContext context) {
    final TextStyle customTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return requests.isEmpty
        ? Column(
            children: <Widget>[
              Text(
                'No requests added yet!',
                style: customTextStyle,
              ),
              SizedBox(height: 20),
            ],
          )
        : ListView.builder(
            itemCount: requests.length,
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  title: Text(
                    requests[index]['title']!,
                    style: customTextStyle,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(requests[index]['title']!),
                        content: Text(requests[index]['details']!),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
