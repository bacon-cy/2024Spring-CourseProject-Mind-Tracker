import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_tracker/mediation.dart';
import 'package:mind_tracker/memo.dart';
import 'package:mind_tracker/mood_chart_page.dart';
import 'package:mind_tracker/mood_page.dart';
import 'package:mind_tracker/post_meditation_mood_page.dart';
import 'package:mind_tracker/start.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: (Colors.blue[800])!,
      ),
    ),
    initialRoute: "/start",
    routes: {
      "/start" : (context) => const StartPage(),
      "/sound" : (context) => const SongScreen(),
      "/memo" : (context) => const MemoPage(),
      "/chart" : (context) => MoodChartPage(),
      "/preMind" : (context) => MoodPage(),
      "/postMind" : (context) => PostMeditationMoodPage(),
    },
  ));
}