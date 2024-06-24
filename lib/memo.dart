import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import "API/STT.dart";
import 'API/TTS.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {

  //global
  final kToday = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  //STT
  bool isRecord = false;
  String speechRecognitionAudioPath = "";
  bool isNeedSendSpeechRecognition = false;
  String base64String = "";
  List<String> items = ["華語", "台語", "華台雙語", "客語", "英語", "印尼語", "粵語"];
  String selectedLanguage = "華語";
  AudioEncoder encoder = AudioEncoder.wav;
  //TTS
  final player = SoundPlayer();
  String sentence = "";
  String language = "國語";

  //function
  void _onDaySelected(DateTime selectedDay,DateTime focusedDay){
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
  }
  List<Event> _getEventsForDay(DateTime day){
    return events[day] ?? [];
  }
  transferText() async{
    if(isNeedSendSpeechRecognition){
      String finalText = await askForService(base64String, selectedLanguage);
      _eventController.text = finalText;
      setState(() {});
    }
  }
  Future<String> askForService(String base64String, String model) {
    return STTClient().askForService(base64String, model);
  }
  Future play(String pathToReadAudio) async {
    await player.play(pathToReadAudio);
    setState(() {
      print("Playing");
      player.isPlaying;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    player.init();
    //********* 根據設備決定錄音的encoder *********//
    if (Platform.isIOS) {
      encoder = AudioEncoder.pcm16bit;
    } else {
      encoder = AudioEncoder.wav;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    return Scaffold(
      appBar: AppBar(
        title: Text("冥想紀錄"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          onPressed: (){
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context,value,_){
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index){
                      return Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: (){},
                          title: Text('${value[index]}'),
                        ),
                      );
                    },
                  );
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return StatefulBuilder(
                              builder: (context, StateSetter setState){
                                return AlertDialog(
                                  scrollable: true,
                                  title: Center(child: Text("新增紀錄")),
                                  content: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: TextField(
                                      controller: _eventController,
                                      onChanged: (value){
                                        setState(() {
                                          sentence = value;
                                        });
                                      },
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //recording
                                            debugPrint('Received click');
                                            final record = Record();
                                            if (isRecord == false) {
                                              if (await record.hasPermission()) {
                                                Directory tempDir = await getTemporaryDirectory();
                                                speechRecognitionAudioPath =
                                                '${tempDir.path}/record.wav';

                                                await record.start(
                                                  numChannels: 1,
                                                  path: speechRecognitionAudioPath,
                                                  encoder: encoder,
                                                  bitRate: 128000,
                                                  samplingRate: 16000,
                                                );
                                                setState(() {
                                                  isRecord = true;
                                                  isNeedSendSpeechRecognition = false;
                                                });
                                              }
                                            }
                                            else {
                                              await record.stop();
                                              var fileBytes = await File(speechRecognitionAudioPath)
                                                  .readAsBytes();

                                              setState(() {
                                                base64String = base64Encode(fileBytes);
                                                isRecord = false;
                                                isNeedSendSpeechRecognition = true;
                                              });
                                            }
                                            //change text controller
                                            await transferText();
                                          },
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            decoration: BoxDecoration(
                                              color: (isRecord == false) ? Colors.white : Colors.red[50],
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Icon(
                                              Icons.mic,
                                              color: (isRecord == false) ? Colors.black : Colors.red,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 45,),
                                        ElevatedButton(
                                            onPressed: (){
                                              List<Event>? tmp = (events[_selectedDay] == null) ? [] : events[_selectedDay];
                                              tmp?.add(Event(_eventController.text));
                                              events.addAll({
                                                _selectedDay!: tmp!,
                                              });
                                              _selectedEvents.value = _getEventsForDay(_selectedDay!);
                                              Navigator.of(context).pop();
                                              _eventController.clear();
                                              setState(() {});
                                            },
                                            child: Text("確認")
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: ()async {
                                            print("clicked");
                                            if (sentence.isEmpty) return;

                                            // 連接到文字轉語音服務器
                                            TTSClient client = TTSClient();
                                            await client.connect();

                                            // 發送語音合成請求，傳遞語言和句子內容
                                            client.send(language, sentence);

                                            // 等待接收服務器的回應
                                            String result = await client.receive();

                                            if (result.isEmpty) {
                                              debugPrint('合成失敗');
                                            } else {
                                              // 解析服務器回傳的 JSON 格式數據
                                              Map<String, dynamic> responseData = json.decode(result);

                                              // 檢查狀態是否正確且有合成的語音文件數據
                                              if (responseData['status'] != null &&
                                                  responseData['status']) {
                                                List<int> resultBytes = base64.decode(responseData['bytes']);
                                                Directory tempDir = await getTemporaryDirectory();
                                                String speechSynthesisAudioPath = '${tempDir.path}/synthesis.wav';
                                                File outputFile = File(speechSynthesisAudioPath);

                                                // 將語音數據寫入文件
                                                await outputFile.writeAsBytes(resultBytes);
                                                debugPrint('File received complete');

                                                // 播放合成的語音文件
                                                play(speechSynthesisAudioPath);

                                              } else {
                                                debugPrint('合成失敗');
                                              }
                                            }
                                            client.close();
                                          },
                                          icon: Icon(Icons.volume_down_outlined),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                          );
                        }
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          TableCalendar<Event>(
            rowHeight: 46,
            headerStyle:const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day){
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay){
              _focusedDay = focusedDay;
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format){
              if(_calendarFormat != format){
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            eventLoader: _getEventsForDay,
          ),
        ],
      ),
    );
  }
}

class Event {
  final String memo;
  const Event(this.memo);

  @override
  String toString() => memo;
}
