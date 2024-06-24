import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mood_data_storage.dart';
import 'more_info_page.dart';

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
        title: const Text('Record Your Mood After Meditation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'How do you feel after meditation?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
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
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _selectedMood == moodLevel ? Colors.blue : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                _getMoodIcon(moodLevel),
                                color: _selectedMood == moodLevel ? Colors.white : Colors.black,
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
                SizedBox(height: 20),
                Text(
                  'Selected Mood Level: $_selectedMood',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveMood();
                  },
                  child: Text('Save Mood'),
                ),
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
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showMessage = false;
      });

      // Navigate to the MoreInfoPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MoreInfoPage()),
      );
    });
  }
}
