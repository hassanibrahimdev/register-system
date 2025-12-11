import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_system/device_info.dart';
import 'package:login_system/pages/login_page/cubit/login_cubit.dart';
import 'package:login_system/pages/login_page/cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late DeviceInfo _deviceInfo;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _deviceInfo = DeviceInfo(context);
    _loginCubit = context.read<LoginCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (BuildContext context, state) {
        if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/profile",
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/register",
                  (route) => false,
                );
              },
              child: Text(
                "Sign Up",
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
                        hintText: "Email",
                        constraints: BoxConstraints(
                          maxWidth: _deviceInfo.width() * 0.6,
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
                          maxWidth: _deviceInfo.width() * 0.6,
                        ),
                      ),
                      controller: _passwordController,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/forget-password");
                      },
                      child: Text("Forgot Password?"),
                    ),
                    SizedBox(height: _deviceInfo.height() * 0.03),
                    BlocSelector<LoginCubit, LoginState, bool>(
                      selector: (LoginState state) {
                        if (state is LoginLoading) {
                          return true;
                        }
                        return false;
                      },
                      builder: (BuildContext context, bool state) {
                        return MaterialButton(
                          onPressed: (!state)
                              ? () {
                                  _loginCubit.login(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                }
                              : null,
                          color: Colors.amberAccent,
                          height: _deviceInfo.width() * 0.03,
                          child: Text("Login"),
                        );
                      },
                    ),
                    BlocSelector<LoginCubit, LoginState, String>(
                      selector: (LoginState state) {
                        if (state is LoginFailure) {
                          return state.message;
                        }
                        if (state is LoginSuccess) {
                          return "Login successfully";
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
            BlocSelector<LoginCubit, LoginState, bool>(
              selector: (LoginState state) {
                if (state is LoginLoading) {
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
