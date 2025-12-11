import 'package:flutter/material.dart';

class DeviceInfo {
  late final BuildContext _context;
  DeviceInfo(BuildContext context){
   _context = context;
  }
  double height() => MediaQuery.of(_context).size.height;
  double width() => MediaQuery.of(_context).size.width;
}