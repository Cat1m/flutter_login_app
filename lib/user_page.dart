// Trong file user_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_login_app/database/database_helper.dart';
import 'package:flutter_login_app/models/user.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper db =
        DatabaseHelper.instance; // Truy cập instance của DatabaseHelper

    return FutureBuilder<List<User>>(
      future: db.fetchDataAsUsers(), // Sử dụng db để fetch dữ liệu
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<User> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(users[index].username!),
            ),
          );
        }
      },
    );
  }
}
