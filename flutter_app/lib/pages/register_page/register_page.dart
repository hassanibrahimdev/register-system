import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_system/device_info.dart';
import 'package:login_system/pages/register_page/cubit/register_state.dart';

import 'cubit/register_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late DeviceInfo _deviceInfo;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late final RegisterCubit _registerCubit;

  @override
  void initState() {
    super.initState();
    _deviceInfo = DeviceInfo(context);
    _registerCubit = context.read<RegisterCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (BuildContext context, RegisterState state) {
        if (state is RegisterSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/profile",
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (route) => false,
                );
              },
              child: Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                  decorationThickness: 2,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: _deviceInfo.width(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        hintText: "Name",
                        constraints: BoxConstraints(
                          maxWidth: _deviceInfo.width() * 0.8,
                        ),
                      ),
                      controller: _nameController,
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
                        hintText: "Confirm password",
                        constraints: BoxConstraints(
                          maxWidth: _deviceInfo.width() * 0.8,
                        ),
                      ),
                      controller: _confirmPasswordController,
                    ),
                    SizedBox(height: _deviceInfo.height() * 0.02),
                    SizedBox(
                      width: _deviceInfo.width() * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextField(
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
                              hintText: "Verify code",
                              constraints: BoxConstraints(
                                maxWidth: _deviceInfo.width() * 0.5,
                              ),
                            ),
                            controller: _verifyCodeController,
                          ),
                          MaterialButton(
                            onPressed: () {
                              _registerCubit.sendVerifyCode(
                                _emailController.text.trim(),
                              );
                            },
                            minWidth: _deviceInfo.width() * 0.02,
                            color: Colors.lightBlue,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Text("Send Code"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _deviceInfo.height() * 0.03),
                    BlocSelector<RegisterCubit, RegisterState, bool>(
                      selector: (RegisterState state) {
                        if (state is RegisterLoading) {
                          return true;
                        }
                        return false;
                      },
                      builder: (BuildContext context, bool state) {
                        return MaterialButton(
                          onPressed: (state)
                              ? null
                              : () {
                                  _registerCubit.signUp(
                                    _nameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    _confirmPasswordController.text.trim(),
                                    _verifyCodeController.text.trim(),
                                  );
                                },
                          color: Colors.amberAccent,
                          height: _deviceInfo.width() * 0.03,
                          minWidth: _deviceInfo.width() * 0.2,
                          child: Text("Sign Up"),
                        );
                      },
                    ),

                    BlocSelector<RegisterCubit, RegisterState, String>(
                      selector: (RegisterState state) {
                        if (state is VerifyCodeFailure) {
                          return state.message;
                        }
                        if (state is RegisterFailure) {
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
            BlocSelector<RegisterCubit, RegisterState, bool>(
              selector: (RegisterState state) {
                if (state is RegisterLoading) {
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
