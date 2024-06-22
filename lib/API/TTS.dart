import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

// int cnt = 0;

class Text2Speech {
  // initialize data
  List<int> data = [];
  // socket state
  bool socketStatus = false;
  // service token
  final String token ="mi2stts";
  // Connect to socket
  // parameter: call back function, speech synthesized text, speech language
  // default model is man
  Future connect(void Function(String) player, String strings, String language ) async {
    String speaker = "";
    int port = 10000;

    if (language=="taiwanese"){
      speaker = "F64";
      language = "tw";
    }
    else if (language=="chinese"){
      speaker = "UDN";
      language = 'zh';
    }
    else if (language=="english"){
      speaker = "en10";
      language = 'en';
    }

    String outmsg = token + "@@@" + strings + "@@@" + speaker +"@@@"+ language;
    print(outmsg);

    if (language=='indonesian'){
      outmsg = token + "@@@" + strings;
      port = 10018;
    }

    //將outmsg轉成byte[]
    List<int> outbyte = utf8.encode(outmsg);
    // print(outbyte);

    //用於計算outmsg和語音檔案串接後的byte數
    var g = Uint32List(4);
    // little endian 轉 big endian
    g[0] = ((outbyte.length & 0xff000000) >>> 24);
    g[1] = ((outbyte.length & 0x00ff0000) >>> 16);
    g[2] = ((outbyte.length & 0x0000ff00) >>> 8);
    g[3] = ((outbyte.length & 0x000000ff));

    // // getTemporaryDirectory(): 取得暫存資料夾，這個資料夾隨時可能被系統或使用者操作清除
    // Directory tempDir = await path_provider.getTemporaryDirectory();
    // // define file path
    // String pathToReadAudio = '${tempDir.path}/SpeechSynthesis_$cnt.wav';

    // cnt++;
    await Socket.connect("140.116.245.147", port).then((socket) async {
      print('------Successfully connected------');
      // 向socket傳送資料
      socket.add(byteconcate(g, outbyte));
      socket.flush();
      // socket監聽
      socket.listen((dataByte) async {
        print('------Data from socket------');
        // Get dataByte from socket
        // 用於串接兩個byte[]
        data = byteconcate(data, dataByte);
        print(data);
      }, onDone: () async {
        print("------Data form socket is done------");
        socket.destroy();

        print("ready to decode");
        Map<String, dynamic> jsonData = jsonDecode(utf8.decode(data));
        print("json data : $jsonData");
        if (jsonData["status"] == false) {
          print("message: " + jsonData["message"]);
        } else {
          // getTemporaryDirectory(): 取得暫存資料夾，這個資料夾隨時可能被系統或使用者操作清除
          Directory tempDir = await path_provider.getTemporaryDirectory();
          // define file path
          String pathToReadAudio = '${tempDir.path}/SpeechSynthesis.wav';
          // create file
          var file = File(pathToReadAudio);
          // write the data to file in byte

          // 解碼 Base64 資料
          List<int> bytes = base64.decode(jsonData["bytes"]);

          await file.writeAsBytes(bytes, flush: true);
          // call back function
          player(pathToReadAudio);
        }
      });
      // catch error
    }).catchError((e) {
      print("socket無法連接: $e");
    });
  }

  //用於串接兩個byte[]
  List<int> byteconcate(List<int> a, List<int> b) {
    // 宣告 result 為 size 是 (a.length + b.length) 的 sign 32bits 的 byte[]
    List<int> result = Int32List(a.length + b.length);

    /// Java的System.arrayCopy(source, sourceOffset, target, targetOffset, length)
    /// = target.setRange(targetOffset, targetOffset + length, source, sourceOffset);
    result.setRange(
        0, a.length, a, 0); // =System.arraycopy(a, 0, result, 0, a.length);
    result.setRange(a.length, a.length + b.length, b,
        0); // =System.arraycopy(b, 0, result, a.length, b.length);

    return result;
  }
}



class SoundPlayer {
  // Declare FlutterSoundPlayer
  FlutterSoundPlayer? _audioPlayer;
  // Set recorder initislised is false
  bool _isPlayerInitialised = false;
  // isPlayer => get status of player (whether is playing)
  bool get isPlaying => _audioPlayer!.isPlaying;

  // initialize player
  Future init() async {
    // Get FlutterSoundPlayer
    _audioPlayer = FlutterSoundPlayer();
    // Open audiosession
    await _audioPlayer!.openAudioSession();
    // set player initislised is true
    _isPlayerInitialised = true;
  }

  // release player
  Future dispose() async {
    // if Recorder isn't initialised => return
    if (!_isPlayerInitialised) return;
    // close audiosession
    await _audioPlayer!.closeAudioSession();
    // set audioplayer is null
    _audioPlayer = null;
    // set player initislised is true
    _isPlayerInitialised = false;
  }

  //start player
  Future play(String pathToReadAudio) async {
    await _audioPlayer!.startPlayer(
      fromURI: pathToReadAudio,
    );
  }

  // stop player
  Future stop() async {
    // if player isn't initialised => return
    if (!_isPlayerInitialised) return;
    // stop player
    await _audioPlayer!.stopPlayer();
  }
}

