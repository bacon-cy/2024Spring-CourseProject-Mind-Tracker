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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Center(
                              child: Text(
                                "冥想之旅",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontFamily: 'OpenSans',
                                  fontSize: 60.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                            child: Center(
                              child: Text(
                                "好好照顧自己",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontFamily: 'OpenSans',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: (){
                                    _swipeController.animateToPage(
                                        0,
                                        duration: Duration(milliseconds: 5),
                                        curve: Curves.easeInOut,
                                    );
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: (){
                                    _smallController.animateToPage(
                                      1,
                                      duration: Duration(milliseconds: 5),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  icon: Icon(Icons.favorite)),
                              IconButton(
                                  onPressed: (){
                                    _swipeController.animateToPage(
                                      2,
                                      duration: Duration(milliseconds: 5),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  icon: Icon(Icons.ssid_chart)),
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
