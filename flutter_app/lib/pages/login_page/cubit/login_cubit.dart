import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login_system/models/login_model.dart';
import 'package:login_system/pages/login_page/cubit/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get("connHost"),
      headers: {"Content-Type": "application/json"},
    ),
  );

  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(LoginFailure(message: "All fields must be filled"));
      return;
    }
    if (!email.trim().endsWith("@gmail.com")) {
      emit(LoginFailure(message: "email should end with @gmail.com"));
      return;
    }
    try {
      LoginModel loginModel = LoginModel(
        email: email.trim(),
        password: password.trim(),
      );

      final response = await dio.post("User/login", data: loginModel.toJson());
      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("id", response.data["id"]);
        await prefs.setString("name", response.data["u"]["name"]);
        await prefs.setString("email", response.data["u"]["email"]);
        await prefs.setString("token", response.data["t"]);
        emit(LoginSuccess());
        return;
      }
      emit(LoginFailure(message: "Something went wrong, please login again!!"));
    } on DioException catch (e) {
      if (e.response != null) {
        // The server responded with a status code (400, 500, etc.)
        emit(LoginFailure(message: e.response!.data.toString()));
      } else {
        // No response received — network error, timeout, DNS issue, etc.
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            emit(
              LoginFailure(message: "Connection timeout. Please try again."),
            );
            break;
          case DioExceptionType.sendTimeout:
            emit(LoginFailure(message: "Send timeout. Please try again."));
            break;
          case DioExceptionType.receiveTimeout:
            emit(LoginFailure(message: "Receive timeout. Please try again."));
            break;
          case DioExceptionType.badCertificate:
            emit(LoginFailure(message: "SSL certificate error."));
            break;
          case DioExceptionType.connectionError:
            emit(LoginFailure(message: "No internet connection."));
            break;
          default:
            emit(
              LoginFailure(message: "Unexpected network error: ${e.message}"),
            );
        }
      }
    }
  }
}
