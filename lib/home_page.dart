import 'package:flutter/material.dart';
import 'package:flutter_login_app/api_service.dart';
import 'package:flutter_login_app/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> data;

  const HomePage({Key? key, required this.data}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("Token trước khi đăng xuất: $token");
    await prefs.remove('token'); // Xóa token từ SharedPreferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          apiService: ApiService
              .create(), // Sử dụng phương t00000000000000000000000000hức create() để tạo instance của ApiService
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = data['username'];
    final token = data['token'];

    return Scaffold(
      appBar: AppBar(title: Text('$username')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: $username'),
            Text('Token: $token'),
            ElevatedButton(
              onPressed: () => _logout(context), // Thêm sự kiện khi nhấn nút
              child: const Text('Đăng Xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
