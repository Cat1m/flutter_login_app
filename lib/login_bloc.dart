import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/api_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;

  LoginBloc({required this.apiService}) : super(LoginInitial()) {
    on<LoginStart>(_onLoginStart);
  }

  Future<void> _onLoginStart(LoginStart event, Emitter<LoginState> emit) async {
    try {
      final response = await apiService.login({
        'username': event.username,
        'password': event.password,
      });

      if (response.body != null) {
        final responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          if (responseBody['Status'] == 'OK') {
            final dataString = responseBody['Data'];
            final data = jsonDecode(dataString); // Giải mã chuỗi Data
            print('Username: ${data['username']}'); // In ra username
            print('Token: ${data['token']}'); // In ra token
            emit(LoginSuccess(data: data)); // Truyền data vào đây
          } else {
            final message =
                responseBody['Messenge'] ?? 'Không có thông báo lỗi';
            emit(LoginFailure(error: 'Login thất bại: $message'));
          }
        } else if (response.statusCode == 401) {
          emit(LoginFailure(error: 'Thông tin đăng nhập không chính xác'));
        } else {
          final error = response.error ?? 'Không có thông tin lỗi';
          emit(LoginFailure(error: 'có lỗi  xảy ra: $error'));
        }
      }
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}

abstract class LoginEvent {}

class LoginStart extends LoginEvent {
  final String username;
  final String password;

  LoginStart({required this.username, required this.password});
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> data;
  LoginSuccess({required this.data});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
