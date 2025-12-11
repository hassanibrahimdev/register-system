import 'package:flutter_bloc/flutter_bloc.dart';
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
}
