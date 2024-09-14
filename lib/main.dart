import 'package:calendar_app/core/app.dart';
import 'package:calendar_app/injections.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}
