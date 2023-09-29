import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_app/api_service.dart';
import 'package:flutter_login_app/database_helper.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

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
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          if (responseBody['Status'] == 'OK') {
            final dataString = responseBody['Data'];
            final data = jsonDecode(dataString);
            print('Data: $data');

            //update data để đảm bảo luôn chỉ lưu 1 user
            await dbHelper.updateData(data);
            List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();

            //các lệnh in ra để kiểm tra thông tin nhận:
            print('row có giá trị là: $rows');
            print('responseBody: $responseBody');
            print('Username: ${data['username']}');
            print('Token: ${data['token']}');

            emit(LoginSuccess(data: data));
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
