class MoodDataStorage {
  static final MoodDataStorage _singleton = MoodDataStorage._internal();
  factory MoodDataStorage() {
    return _singleton;
  }
  MoodDataStorage._internal();

  List<int> _preMeditationMoodData = [];
  List<int> _postMeditationMoodData = [];

  void addPreMeditationMoodData(int mood) {
    _preMeditationMoodData.add(mood);
  }

  void addPostMeditationMoodData(int mood) {
    _postMeditationMoodData.add(mood);
  }

  List<int> getPreMeditationMoodData() {
    return _preMeditationMoodData;
  }

  List<int> getPostMeditationMoodData() {
    return _postMeditationMoodData;
  }
}
