import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login_system/pages/forget_password_page/cubit/forget_password_cubit.dart';
import 'package:login_system/pages/forget_password_page/forget_password_page.dart';
import 'package:login_system/pages/home_page/home_page.dart';
import 'package:login_system/pages/login_page/cubit/login_cubit.dart';
import 'package:login_system/pages/login_page/login_page.dart';
import 'package:login_system/pages/profile_page/cubit/profile_cubit.dart';
import 'package:login_system/pages/profile_page/profile_page.dart';
import 'package:login_system/pages/register_page/cubit/register_cubit.dart';
import 'package:login_system/pages/register_page/register_page.dart';
import 'package:login_system/pages/reset_password_page/cubit/reset_password_cubit.dart';
import 'package:login_system/pages/reset_password_page/reset_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

String iRoute = "/home";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setRoute();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

Future<void> setRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString("token") != null) {
    iRoute = "/profile";
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: iRoute,
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => BlocProvider<LoginCubit>(
          create: (BuildContext context) {
            return LoginCubit();
          },
          child: const LoginPage(),
        ),
        '/register': (context) => BlocProvider<RegisterCubit>(
          create: (BuildContext context) {
            return RegisterCubit();
          },
          child: const RegisterPage(),
        ),
        '/profile': (context) => BlocProvider<ProfileCubit>(
          create: (BuildContext context) {
            return ProfileCubit();
          },
          child: const ProfilePage(),
        ),
        '/reset-password': (context) => BlocProvider<ResetPasswordCubit>(
          create: (BuildContext context) {
            return ResetPasswordCubit();
          },
          child: ResetPasswordPage(),
        ),
        '/forget-password': (context) => BlocProvider<ForgetPasswordCubit>(
          create: (BuildContext context) {
            return ForgetPasswordCubit();
          },
          child: const ForgetPasswordPage(),
        ),
      },
    );
  }
}
