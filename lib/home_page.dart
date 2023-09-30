// Trong file home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_login_app/api_service.dart';
import 'package:flutter_login_app/database/database_helper.dart';

import 'package:flutter_login_app/login_page.dart';
import 'package:flutter_login_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  HomePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("Token trước khi đăng xuất: $token");
    await prefs.remove('token'); // Xóa token từ SharedPreferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          apiService: ApiService.create(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: dbHelper.fetchDataAsUsers(), // Lấy dữ liệu từ database
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Hiển thị loading khi đang chờ dữ liệu
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Hiển thị lỗi nếu có
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
              'Không có dữ liệu'); // Hiển thị thông báo nếu không có dữ liệu
        } else {
          final user = snapshot.data!.first;
          // Lấy dữ liệu đầu tiên từ kết quả trả về
          final username = user.username;
          final token = user.token;
          final deviceId = user.deviceId;

          return Scaffold(
            appBar: AppBar(title: Text('$username')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Username: $username'),
                  Text('Token: $token'),
                  Text('ID: $deviceId'),
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    child: const Text('Đăng Xuất'),
                  ),
                  // Phần hiển thị bảng dữ liệu giữ nguyên
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
