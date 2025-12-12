import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login_system/models/forget_password_model.dart';
import 'package:login_system/pages/forget_password_page/cubit/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get("connHost"),
      headers: {"Content-Type": "application/json"},
    ),
  );

  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  Future<void> sendVerifyCode(String email) async {
    if (email.trim().isEmpty) {
      emit(ForgetPasswordFailure(message: "email must be filled"));
      return;
    }
    if(!email.trim().endsWith("@gmail.com")){
      emit(ForgetPasswordFailure(message: "email must end with '@gmail.com'"));
      return;
    }
    final response = await dio.post(
      "User/verificationcode",
      data: '"$email"', // raw json string
    );
    if (response.statusCode == 200) {
      return;
    }
    emit(ForgetPasswordFailure(message: "Something went wrong"));
  }

  Future<void> forgetPassword(
    String email,
    String password,
    String confirmPassword,
    String verifyCode,
  ) async {
    if (email.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty ||
        verifyCode.trim().isEmpty) {
      emit(ForgetPasswordFailure(message: "All fields must be filled"));
      return;
    }
    if (password.trim().length < 8) {
      emit(
        ForgetPasswordFailure(message: "password length should be more than 7"),
      );
      return;
    }
    if (password.trim() != confirmPassword.trim()) {
      emit(
        ForgetPasswordFailure(
          message: "password and confirm password not match",
        ),
      );
      return;
    }
    if (!email.trim().endsWith("@gmail.com")) {
      emit(ForgetPasswordFailure(message: "email should end with @gmail.com"));
      return;
    }
    emit(ForgetPasswordLoading());
    try {
      ForgetPasswordModel forgetPasswordModel = ForgetPasswordModel(
        email: email.trim(),
        password: password.trim(),
        confirmPassword: confirmPassword.trim(),
        verifyCode: verifyCode.trim(),
      );
      final response = await dio.put(
        "User/forgetpassword",
        data: forgetPasswordModel.toJson(),
      );
      if (response.statusCode == 200) {
        emit(ForgetPasswordSuccess());
        return;
      }
      emit(ForgetPasswordFailure(message: "Something went wrong"));
    } catch (e) {
      emit(ForgetPasswordFailure(message: e.toString()));
    }
  }
}
