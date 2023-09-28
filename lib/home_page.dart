import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> data;

  const HomePage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = data['username']; // truy cập username từ data
    final token = data['token']; // truy cập token từ data

    return Scaffold(
      appBar: AppBar(title: Text('$username')), // hiển thị username trên AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: $username'), // hiển thị username
            Text('Token: $token'), // hiển thị token
          ],
        ),
      ),
    );
  }
}
