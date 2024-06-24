import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

const String SERVER = '140.116.245.147';
const int PORT = 9999;
const String END_OF_TRANSMISSION = 'EOT';

class TTSClient {
  late Socket _socket;
  final String _token = 'mi2stts';
  final String _id = '10012';
  final Map<String, String> languageIdMap = {
    "國語": "zh",
    "台語": "tw",
    "客語": "hakka",
    "英語": "en",
    "印尼語": "id",
  };

  Future<void> connect() async {
    _socket = await Socket.connect(SERVER, PORT);
  }

  void send(String language, String data) {
    String speaker = "4780";
    String language_id = languageIdMap[language]!;
    debugPrint('$_id@@@$_token@@@$language_id@@@$speaker@@@$data');
    List<int> bytes = utf8.encode('$_id@@@$_token@@@$language_id@@@$speaker@@@$data').toList();
    bytes.addAll(utf8.encode(END_OF_TRANSMISSION));
    _socket.add(bytes);
  }

  Future<String> receive() async {
    List<int> data = [];
    await for (List<int> chunk in _socket) {
      data.addAll(chunk);
    }
    return utf8.decode(data);
  }

  void close() {
    _socket.close();
  }
}

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer; // FlutterSoundPlayer 實例，用於播放音頻
  bool _isPlayerInitialised = false; // 標記音頻播放器是否已初始化
  bool get isPlaying => _audioPlayer!.isPlaying; // 獲取當前音頻播放器的播放狀態

  // 初始化音頻播放器
  Future init() async {
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer!.openAudioSession();
    _isPlayerInitialised = true;
  }

  // 釋放音頻播放器資源
  Future dispose() async {
    if (!_isPlayerInitialised) return;
    await _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
    _isPlayerInitialised = false;
  }

  // 播放指定路徑的音頻文件
  Future play(String pathToReadAudio) async {
    await _audioPlayer!.startPlayer(
      fromURI: pathToReadAudio,
    );
  }

  // 停止音頻播放
  Future stop() async {
    if (!_isPlayerInitialised) return;
    await _audioPlayer!.stopPlayer();
  }
}