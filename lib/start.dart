import 'package:flutter/material.dart';
import 'package:mind_tracker/clipper.dart';
import 'package:mind_tracker/memo.dart';
import 'package:mind_tracker/mood_chart_page.dart';
import 'package:mind_tracker/mood_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _swipeController = PageController(initialPage: 1);
    final _smallController = PageController(initialPage: 0);
    return Scaffold(
      body: PageView(
        controller: _swipeController,
        children: [
          MemoPage(),
          PageView(
            scrollDirection: Axis.vertical,
            controller: _smallController,
            children: [
              Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFFFDE7),
                          Color(0xFFFFF9C4),
                          Color(0xFFFFF59D),
                          Color(0xFFFFF176)
                        ],
                        stops: [0.1,0.4,0.7,0.9],
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      color: Theme.of(context).colorScheme.onPrimary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/cover.png',
                              fit: BoxFit.cover),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _swipeController.animateToPage(
                                          0,
                                          duration: Duration(milliseconds: 5),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      icon: const Icon(Icons.edit)),
                                  const Text(
                                    "心情紀錄",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _smallController.animateToPage(
                                        1,
                                        duration: Duration(milliseconds: 5),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    icon: const Icon(Icons.eco_rounded),
                                    //icon: Icon(Icons.auto_awesome_rounded)
                                  ),
                                  const Text(
                                    "開始冥想",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _swipeController.animateToPage(
                                        2,
                                        duration: Duration(milliseconds: 5),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    icon: const Icon(Icons.equalizer),
                                    //icon: Icon(Icons.ssid_chart)
                                  ),
                                  const Text(
                                    "心情曲線",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              MoodPage(),
            ],
          ),
          MoodChartPage(),
        ],
      ),
    );
  }
}
