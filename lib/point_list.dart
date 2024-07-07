import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'point_details_screen.dart'; // 새로운 파일을 import

const String baseUrl = 'http://172.10.7.128:80/pointslist/';

class Tab1Screen extends StatefulWidget {
  const Tab1Screen({Key? key}) : super(key: key);

  @override
  _Tab1ScreenState createState() => _Tab1ScreenState();
}

class _Tab1ScreenState extends State<Tab1Screen> {
  List<Map<String, dynamic>> pointLists = [];

  Future<void> getPointsLists() async {
    String url = baseUrl;

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          pointLists = data.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      } else {
        print('Response not ok with url: $url, status: ${response.statusCode}, statusText: ${response.reasonPhrase}');
        throw Exception('HTTP error! Status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching point lists: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getPointsLists();
  }

  void navigateToDetails(Map<String, dynamic> pointList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PointDetailsScreen(pointList: pointList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Point Lists'),
      ),
      body: Center(
        child: pointLists.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: pointLists.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(pointLists[index]['name']),
                subtitle: Text('Points: ${pointLists[index]['points'].length}'),
                onTap: () => navigateToDetails(pointLists[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
