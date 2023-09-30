import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/home_page.dart';

import 'package:flutter_login_app/login_bloc.dart';
import 'package:flutter_login_app/login_page.dart';
import 'package:flutter_login_app/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final apiService = ApiService.create();
  runApp(MyApp(apiService: apiService, initialToken: token));
  print('token hiện tại : $token');
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final String? initialToken;
  const MyApp({required this.apiService, this.initialToken, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
              create: (context) => LoginBloc(apiService: apiService),
              child: initialToken == null
                  ? LoginPage(apiService: apiService)
                  : HomePage(),
            ),
      },
    );
  }
}
