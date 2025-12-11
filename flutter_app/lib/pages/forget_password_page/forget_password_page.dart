import 'package:flutter/material.dart';
import 'package:login_system/device_info.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late DeviceInfo _deviceInfo;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deviceInfo = DeviceInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forget Password")),
      body: Center(
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
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          hintText: "Verify Code",
                        ),
                        controller: _emailController,
                      ),
                    ),
                    SizedBox(width: _deviceInfo.width() * 0.01,),
                    Expanded(
                      flex: 2,
                      child: MaterialButton(
                        onPressed: () {},
                        color: Colors.lightBlue,
                        height: 50,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text("Send Code"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _deviceInfo.height() * 0.04),
              MaterialButton(
                onPressed: () {},
                color: Colors.amberAccent,
                height: 50,
                minWidth: _deviceInfo.width()*0.2,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
