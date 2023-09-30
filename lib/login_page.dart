import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/api_service.dart';
import 'package:flutter_login_app/home_page.dart';
import 'package:flutter_login_app/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  final ApiService apiService;

  const LoginPage({required this.apiService, Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(text: "84123456");
  final _passwordController = TextEditingController(text: "abc@123456");
  String appBarTitle = 'Đăng Nhập'; // Khởi tạo giá trị mặc định cho appBarTitle

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token Saved: $token');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(apiService: widget.apiService),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            final data = state.data;
            if (data['username'] != null) {
              setState(() {
                appBarTitle =
                    data['username']; // Cập nhật giá trị của appBarTitle
              });
            }
            saveToken(data['token']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
                title:
                    Text(appBarTitle)), // Sử dụng giá trị của appBarTitle ở đây
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration:
                        const InputDecoration(labelText: 'Tên đăng nhập'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(LoginStart(
                            username: _usernameController.text,
                            password: _passwordController.text,
                          ));
                    },
                    child: const Text('Đăng Nhập'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
