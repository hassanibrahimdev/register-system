import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login_system/models/reset_password_model.dart';
import 'package:login_system/pages/reset_password_page/cubit/reset_password_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword(String password, String confirmPassword) async {
    emit(ResetPasswordLoading());
    if (password.trim().isEmpty || confirmPassword.trim().isEmpty) {
      emit(ResetPasswordFailure(message: "All fields must be filled"));
      return;
    }
    if (password.trim().length < 8) {
      emit(
        ResetPasswordFailure(
          message: "password should be at least 8 characters",
        ),
      );
      return;
    }
    if (password.trim() != confirmPassword.trim()) {
      emit(
        ResetPasswordFailure(
          message: "password and confirm password should match",
        ),
      );
      return;
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      String? token = prefs.getString("token");

      ResetPasswordModel resetPasswordModel = ResetPasswordModel(
        id: id ?? "",
        password: password.trim(),
        confirmPassword: confirmPassword.trim(),
      );
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: dotenv.get("connHost"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      final response = await dio.put(
        "User/resetpassword",
        data: resetPasswordModel.toJson(),
      );
      print(response);

      if (response.statusCode == 200) {
        emit(ResetPasswordSuccess());
        return;
      }
      emit(ResetPasswordFailure(message: "Something went wrong"));
    } on DioException catch (e) {
      if (e.response != null) {
        // The server responded with a status code (400, 500, etc.)
        emit(ResetPasswordFailure(message: e.response!.data.toString()));
      } else {
        // No response received — network error, timeout, DNS issue, etc.
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            emit(
              ResetPasswordFailure(
                message: "Connection timeout. Please try again.",
              ),
            );
            break;
          case DioExceptionType.sendTimeout:
            emit(
              ResetPasswordFailure(message: "Send timeout. Please try again."),
            );
            break;
          case DioExceptionType.receiveTimeout:
            emit(
              ResetPasswordFailure(
                message: "Receive timeout. Please try again.",
              ),
            );
            break;
          case DioExceptionType.badCertificate:
            emit(ResetPasswordFailure(message: "SSL certificate error."));
            break;
          case DioExceptionType.connectionError:
            emit(ResetPasswordFailure(message: "No internet connection."));
            break;
          default:
            emit(
              ResetPasswordFailure(
                message: "Unexpected network error: ${e.message}",
              ),
            );
        }
      }
    }
  }
}
