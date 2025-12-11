import 'package:flutter/material.dart';
import 'package:login_system/device_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DeviceInfo _deviceInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deviceInfo = DeviceInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login System",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "welcome to this app",
            style: TextStyle(
              color: Colors.black,
              fontSize: _deviceInfo.width() * 0.05,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "if you are new here please",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: _deviceInfo.width() * 0.05,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/register");
                },
                child: Text(
                  "register",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: _deviceInfo.width() * 0.05,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "if not new please ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: _deviceInfo.width() * 0.05,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: Text(
                  "login",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: _deviceInfo.width() * 0.05,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
