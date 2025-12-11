import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_system/device_info.dart';
import 'package:login_system/pages/reset_password_page/cubit/reset_password_cubit.dart';
import 'package:login_system/pages/reset_password_page/cubit/reset_password_state.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late DeviceInfo _deviceInfo;
  late ResetPasswordCubit _resetPasswordCubit;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _deviceInfo = DeviceInfo(context);
    _resetPasswordCubit = context.read<ResetPasswordCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (BuildContext context, ResetPasswordState state) {
        if (state is ResetPasswordSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/profile",
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Reset Password")),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        hintText: "Password",
                        constraints: BoxConstraints(
                          maxWidth: _deviceInfo.width() * 0.8,
                        ),
                      ),
                      controller: _passwordController,
                    ),
                    SizedBox(height: _deviceInfo.height() * 0.02),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        hintText: "Confirm Password",
                        constraints: BoxConstraints(
                          maxWidth: _deviceInfo.width() * 0.8,
                        ),
                      ),
                      controller: _confirmPasswordController,
                    ),
                    SizedBox(height: _deviceInfo.height() * 0.02),
                    BlocSelector<ResetPasswordCubit, ResetPasswordState, bool>(
                      selector: (ResetPasswordState state) {
                        if (state is ResetPasswordLoading) {
                          return true;
                        }
                        return false;
                      },
                      builder: (BuildContext context, bool state) {
                        return MaterialButton(
                          onPressed: (state)
                              ? null
                              : () {
                                  _resetPasswordCubit.resetPassword(
                                    _passwordController.text.trim(),
                                    _confirmPasswordController.text.trim(),
                                  );
                                },
                          color: Colors.amberAccent,
                          child: Text("Reset Password"),
                        );
                      },
                    ),
                    BlocSelector<
                      ResetPasswordCubit,
                      ResetPasswordState,
                      String
                    >(
                      selector: (ResetPasswordState state) {
                        if (state is ResetPasswordFailure) {
                          return state.message;
                        }
                        return "";
                      },
                      builder: (BuildContext context, String state) {
                        return Text(state);
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocSelector<ResetPasswordCubit, ResetPasswordState, bool>(
              selector: (ResetPasswordState state) {
                if (state is ResetPasswordLoading) {
                  return true;
                }
                return false;
              },

              builder: (BuildContext context, bool state) {
                return (state)
                    ? Center(child: CircularProgressIndicator())
                    : Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
