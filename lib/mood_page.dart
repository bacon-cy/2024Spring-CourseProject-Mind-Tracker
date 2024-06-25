import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mood_data_storage.dart';
import 'route_observer.dart'; // Add this import
import 'color_control.dart';

class MoodPage extends StatefulWidget {
  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> with RouteAware {
  int _selectedMood = 5; // Default mood level
  bool _moodSaved = false; // To control the button text
  bool _showMessage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      RouteObserverProvider.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      RouteObserverProvider.routeObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didPopNext() {
    // Reset state when returning from the meditation page
    setState(() {
      _selectedMood = 5;
      _moodSaved = false;
      _showMessage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('紀錄當下的心情'),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                Text(
                  '你想給現在的心情打幾分呢？',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      int moodLevel = index + 1;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMood = moodLevel;
                          });
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 7.8),
                          decoration: BoxDecoration(
                            color: _selectedMood == moodLevel
                                ? getColor(13)
                                : getColor(moodLevel),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                _getMoodIcon(moodLevel),
                                color: _selectedMood == moodLevel
                                    ? Colors.white
                                    : Colors.black,
                                size: 30,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '$moodLevel',
                                style: TextStyle(
                                  color: _selectedMood == moodLevel ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      int moodLevel = index + 6;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMood = moodLevel;
                          });
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 7.7),
                          decoration: BoxDecoration(
                            color: _selectedMood == moodLevel
                                ? getColor(13)
                                : getColor(moodLevel),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                _getMoodIcon(moodLevel),
                                color: _selectedMood == moodLevel
                                    ? Colors.white
                                    : Colors.black,
                                size: 30,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '$moodLevel',
                                style: TextStyle(
                                  color: _selectedMood == moodLevel
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 120),
                ElevatedButton(
                  style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(
                    EdgeInsets.all(20),
                  )),
                  onPressed: () {
                    if (_moodSaved) {
                      Navigator.pushReplacementNamed(context, "/sound");
                    } else {
                      _saveMood();
                    }
                  },
                  child: Text(
                    _moodSaved ? '開始冥想' : '儲存心情分數',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '目前選擇 : $_selectedMood分',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 60),
              ],
            ),
            if (_showMessage)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.green,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mood saved!',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _showMessage = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getMoodIcon(int moodLevel) {
    if (moodLevel < 5) {
      return FontAwesomeIcons.solidFrown; // Sad icon
    } else if (moodLevel == 5) {
      return FontAwesomeIcons.meh; // Stony-faced icon
    } else {
      return FontAwesomeIcons.solidSmile; // Smile icon
    }
  }

  void _saveMood() {
    setState(() {
      _moodSaved = true;
      _showMessage = true;
    });

    // Save the mood data as pre-meditation
    MoodDataStorage().addPreMeditationMoodData(_selectedMood);

    // Show the message for 3 seconds
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showMessage = false;
      });
    });
  }
}
