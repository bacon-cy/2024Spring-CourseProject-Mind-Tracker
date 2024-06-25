import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'mood_data_storage.dart';

class MoodChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<int> preMoodData = MoodDataStorage().getPreMeditationMoodData();
    List<int> postMoodData = MoodDataStorage().getPostMeditationMoodData();

    // Ensure the lengths of preMoodData and postMoodData are equal
    int maxLength = preMoodData.length > postMoodData.length ? preMoodData.length : postMoodData.length;

    // Prepare data points for before and after meditation
    List<ChartData> chartData = List.generate(maxLength, (index) {
      int preMood = index < preMoodData.length ? preMoodData[index] : null!;
      int postMood = index < postMoodData.length ? postMoodData[index] : null!;
      return ChartData(index + 1, preMood, postMood);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('心情曲線'),
      ),
      body: SfCartesianChart(
        primaryXAxis: NumericAxis(
          title: AxisTitle(text: '時間'),
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: '心情指數'),
          majorGridLines: MajorGridLines(width: 0),
          minimum: 1,
          maximum: 10,
        ),
        legend: Legend(isVisible: true),
        series: <CartesianSeries>[
          LineSeries<ChartData, int>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.time,
            yValueMapper: (ChartData data, _) => data.beforeMood,
            name: '冥想前',
          ),
          LineSeries<ChartData, int>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.time,
            yValueMapper: (ChartData data, _) => data.postMood,
            name: '冥想後',
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final int time;
  final int? beforeMood;
  final int? postMood;

  ChartData(this.time, this.beforeMood, this.postMood);
}
