import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login_system/models/user_model.dart';
import 'package:login_system/pages/profile_page/cubit/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("id");
      String? name = prefs.getString("name");
      String? email = prefs.getString("email");

      emit(
        ProfileSuccess(
          user: UserModel(id: id ?? "", name: name ?? "", email: email ?? ""),
        ),
      );
    } catch (e) {
      emit(ProfileFailure());
    }
  }

  Future<void> logout() async {
    emit(ProfileLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    emit(ProfileFailure());
  }

  Future<void> deleteProfile() async {
    emit(ProfileLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: dotenv.get("connHost"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    final response = await dio.delete("User/deleteuser");
    if (response.statusCode == 200) {
      await prefs.clear();
      emit(ProfileDelete());
      return;
    }
    emit(ProfileFailure());
  }
}
