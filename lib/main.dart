import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_tracker/memo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: (Colors.blue[800])!,
      ),
    ),
    initialRoute: "/memo",
    routes: {
      "/memo" : (context) => const MemoPage(),
    },
  ));
}