import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_system/device_info.dart';
import 'package:login_system/pages/profile_page/cubit/profile_cubit.dart';
import 'package:login_system/pages/profile_page/cubit/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileCubit _profileCubit;
  late DeviceInfo _deviceInfo;

  @override
  void initState() {
    super.initState();
    _deviceInfo = DeviceInfo(context);
    _profileCubit = context.read<ProfileCubit>();
    _profileCubit.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (BuildContext context, state) {
        if (state is ProfileFailure) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/login",
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocSelector<ProfileCubit, ProfileState, String>(
                selector: (ProfileState state) {
                  if (state is ProfileSuccess) {
                    return state.user.id;
                  }
                  return "";
                },
                builder: (BuildContext context, String state) {
                  return Text("id: ${state.trim()}");
                },
              ),
              SizedBox(height: _deviceInfo.height() * 0.005),
              BlocSelector<ProfileCubit, ProfileState, String>(
                selector: (ProfileState state) {
                  if (state is ProfileSuccess) {
                    return state.user.name;
                  }
                  return "";
                },
                builder: (BuildContext context, String state) {
                  return Text("name: ${state.trim()}");
                },
              ),
              SizedBox(height: _deviceInfo.height() * 0.005),
              BlocSelector<ProfileCubit, ProfileState, String>(
                selector: (ProfileState state) {
                  if (state is ProfileSuccess) {
                    return state.user.email;
                  }
                  return "";
                },
                builder: (BuildContext context, String state) {
                  return Text("email: ${state.trim()}");
                },
              ),
              SizedBox(height: _deviceInfo.height() * 0.02),
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/reset-password');
                },
                color: Colors.lightBlueAccent,
                child: Text("Reset Password"),
              ),
              SizedBox(height: _deviceInfo.height() * 0.02),
              MaterialButton(
                onPressed: () {
                  _profileCubit.logout();
                },
                color: Colors.redAccent,
                child: Text("Logout"),
              ),
              SizedBox(height: _deviceInfo.height() * 0.02),
              MaterialButton(
                onPressed: () {},
                color: Colors.red,
                child: Text("Delete Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
