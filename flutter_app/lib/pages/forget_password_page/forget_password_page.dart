import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_system/device_info.dart';
import 'package:login_system/pages/forget_password_page/cubit/forget_password_cubit.dart';
import 'package:login_system/pages/forget_password_page/cubit/forget_password_state.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late DeviceInfo _deviceInfo;
  late final ForgetPasswordCubit _forgetPasswordCubit;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deviceInfo = DeviceInfo(context);
    _forgetPasswordCubit = context.read<ForgetPasswordCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (BuildContext context, ForgetPasswordState state) {
        if (state is ForgetPasswordSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/login",
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Forget Password")),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
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
                        hintText: "Email",
                        constraints: BoxConstraints(
                          maxWidth: _deviceInfo.width() * 0.8,
                        ),
                      ),
                      controller: _emailController,
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
                        hintText: "password",
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
                    SizedBox(
                      width: _deviceInfo.width() * 0.8,
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                hintText: "Verify Code",
                              ),
                              controller: _verifyCodeController,
                            ),
                          ),
                          SizedBox(width: _deviceInfo.width() * 0.01),
                          Expanded(
                            flex: 2,
                            child: MaterialButton(
                              onPressed: () {
                                _forgetPasswordCubit.sendVerifyCode(
                                  _emailController.text.trim(),
                                );
                              },
                              color: Colors.lightBlue,
                              height: 50,
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Text("Send Code"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _deviceInfo.height() * 0.04),
                    BlocSelector<
                      ForgetPasswordCubit,
                      ForgetPasswordState,
                      bool
                    >(
                      selector: (ForgetPasswordState state) {
                        if (state is ForgetPasswordLoading) {
                          return true;
                        }
                        return false;
                      },

                      builder: (BuildContext context, bool state) {
                        return MaterialButton(
                          onPressed: (state)
                              ? null
                              : () {
                                  _forgetPasswordCubit.forgetPassword(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    _confirmPasswordController.text.trim(),
                                    _verifyCodeController.text.trim(),
                                  );
                                },
                          color: Colors.amberAccent,
                          height: 50,
                          minWidth: _deviceInfo.width() * 0.2,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text("Reset Password"),
                        );
                      },
                    ),
                    BlocSelector<
                      ForgetPasswordCubit,
                      ForgetPasswordState,
                      String
                    >(
                      selector: (ForgetPasswordState state) {
                        if(state is ForgetPasswordFailure){
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
            BlocSelector<ForgetPasswordCubit, ForgetPasswordState, bool>(
              selector: (ForgetPasswordState state) {
                if (state is ForgetPasswordLoading) {
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
