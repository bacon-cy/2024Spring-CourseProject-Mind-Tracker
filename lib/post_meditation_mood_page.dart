import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_tracker/memo.dart';
import 'mood_data_storage.dart';
import 'color_control.dart';

class PostMeditationMoodPage extends StatefulWidget {
  @override
  _PostMeditationMoodPageState createState() => _PostMeditationMoodPageState();
}

class _PostMeditationMoodPageState extends State<PostMeditationMoodPage> {
  int _selectedMood = 5; // Default mood level
// To control the button text
  bool _showMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Record Your Mood After Meditation'),
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
                  '現在，你想給你的心情打幾分呢？',
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
                    _saveMood();
                  },
                  child: Text('儲存心情分數'),
                ),
                const SizedBox(height: 20),
                Text(
                  '目前選擇 : $_selectedMood分',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 120),
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
      return FontAwesomeIcons.solidFaceFrown; // Sad icon
    } else if (moodLevel == 5) {
      return FontAwesomeIcons.faceMeh; // Stony-faced icon
    } else {
      return FontAwesomeIcons.solidFaceSmile; // Smile icon
    }
  }

  void _saveMood() {
    setState(() {
      _showMessage = true;
    });

    // Save the mood data as post-meditation
    MoodDataStorage().addPostMeditationMoodData(_selectedMood);

    // Show the message for 3 seconds
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showMessage = false;
      });

      // Navigate to the MoreInfoPage
      Navigator.pushNamed(context, "/memo");
    });
  }
}
