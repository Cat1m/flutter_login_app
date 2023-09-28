import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/login_bloc.dart';
import 'package:flutter_login_app/login_page.dart';
import 'api_service.dart';

void main() {
  final apiService = ApiService.create();
  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  const MyApp({required this.apiService, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
              create: (context) => LoginBloc(apiService: apiService),
              child: LoginPage(apiService: apiService),
            ),
      },
    );
  }
}
