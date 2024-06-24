import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "冥想APP",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Center(
                  child: Text(
                    "好好照顧自己",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
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
                        Navigator.pushReplacementNamed(context, "/chart");
                      },
                      icon: Icon(Icons.ssid_chart)),
                  IconButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, "/memo");
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, "/chart");
                      },
                      icon: Icon(Icons.ssid_chart)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
