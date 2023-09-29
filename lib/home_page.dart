// Trong file home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_login_app/api_service.dart';
import 'package:flutter_login_app/database_helper.dart';
import 'package:flutter_login_app/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> data;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  HomePage({Key? key, required this.data}) : super(key: key);

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
              onPressed: () => _logout(context),
              child: const Text('Đăng Xuất'),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHelper.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data;

                  return DataTable(
                    dataTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.amber),
                    columns: const [
                      DataColumn(
                        label: Text('ID'),
                      ),
                      DataColumn(
                        label: Text('Username'),
                      ),
                      DataColumn(
                        label: Text('Token'),
                      ),
                    ],
                    rows: data!
                        .map((row) => DataRow(cells: [
                              DataCell(
                                Text(
                                  row['id'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  row['username'],
                                ),
                              ),
                              DataCell(
                                Text(
                                  row['token'],
                                ),
                              ),
                            ]))
                        .toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
