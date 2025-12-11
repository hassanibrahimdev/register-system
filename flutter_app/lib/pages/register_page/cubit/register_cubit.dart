import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login_system/models/signup_model.dart';
import 'package:login_system/pages/register_page/cubit/register_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get("connHost"),
      headers: {"Content-Type": "application/json"},
    ),
  );

  RegisterCubit() : super(RegisterInitial());

  Future<void> sendVerifyCode(String email) async {
    if (email.isEmpty) {
      emit(VerifyCodeFailure(message: "email must be filled"));
      return;
    }
    emit(VerifyCodeLoading());
    try {
      final response = await dio.post(
        "User/verificationcode",
        data: '"$email"', // raw json string
      );
      emit(VerifyCodeSuccess(message: "code send successfully"));
    } on DioException catch (e) {
      if (e.response != null) {
        // The server responded with a status code (400, 500, etc.)
        emit(VerifyCodeFailure(message: e.response!.data.toString()));
      } else {
        // No response received — network error, timeout, DNS issue, etc.
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            emit(
              VerifyCodeFailure(
                message: "Connection timeout. Please try again.",
              ),
            );
            break;
          case DioExceptionType.sendTimeout:
            emit(VerifyCodeFailure(message: "Send timeout. Please try again."));
            break;
          case DioExceptionType.receiveTimeout:
            emit(
              VerifyCodeFailure(message: "Receive timeout. Please try again."),
            );
            break;
          case DioExceptionType.badCertificate:
            emit(VerifyCodeFailure(message: "SSL certificate error."));
            break;
          case DioExceptionType.connectionError:
            emit(VerifyCodeFailure(message: "No internet connection."));
            break;
          default:
            emit(
              VerifyCodeFailure(
                message: "Unexpected network error: ${e.message}",
              ),
            );
        }
      }
    }
  }

  Future<void> signUp(
    String name,
    String email,
    String password,
    String confirmPassword,
    String verifyCode,
  ) async {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty ||
        verifyCode.trim().isEmpty) {
      emit(RegisterFailure(message: "All fields must be filled"));
      return;
    }
    if (password.trim().length < 8) {
      emit(RegisterFailure(message: "password length should be more than 7"));
      return;
    }
    if (password.trim() != confirmPassword.trim()) {
      emit(RegisterFailure(message: "password and confirm password not match"));
      return;
    }
    if (!email.trim().endsWith("@gmail.com")) {
      emit(RegisterFailure(message: "email should end with @gmail.com"));
      return;
    }
    emit(RegisterLoading());
    try {
      SignupModel signupModel = SignupModel(
        name: name.trim(),
        email: email.trim(),
        password: password.trim(),
        confirmPassword: confirmPassword.trim(),
        verifyCode: verifyCode.trim(),
      );

      final response = await dio.post(
        "User/signup",
        data: signupModel.toJson(),
      );
      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("id", response.data["id"]);
        await prefs.setString("name", response.data["u"]["name"]);
        await prefs.setString("email", response.data["u"]["email"]);
        await prefs.setString("token", response.data["t"]);
        emit(RegisterSuccess());
        return;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // The server responded with a status code (400, 500, etc.)
        emit(RegisterFailure(message: e.response!.data.toString()));
      } else {
        // No response received — network error, timeout, DNS issue, etc.
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            emit(
              RegisterFailure(message: "Connection timeout. Please try again."),
            );
            break;
          case DioExceptionType.sendTimeout:
            emit(RegisterFailure(message: "Send timeout. Please try again."));
            break;
          case DioExceptionType.receiveTimeout:
            emit(
              RegisterFailure(message: "Receive timeout. Please try again."),
            );
            break;
          case DioExceptionType.badCertificate:
            emit(RegisterFailure(message: "SSL certificate error."));
            break;
          case DioExceptionType.connectionError:
            emit(RegisterFailure(message: "No internet connection."));
            break;
          default:
            emit(
              RegisterFailure(
                message: "Unexpected network error: ${e.message}",
              ),
            );
        }
      }
    }
  }
}
