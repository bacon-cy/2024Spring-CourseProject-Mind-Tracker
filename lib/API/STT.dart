import 'dart:convert';
import 'package:http/http.dart' as http;

class STTClient {
  final String token =
      "btRkfZr5Ndy2tkpnRfZ3b9ER9ndEC6rxYEg5Vu8XCCuK85KRDKw9cFhcYQ3VdXBQ";

  Future<String> askForService(String base64String, String language) async {
    // var fileBytes = await File(speechRecognitionAudioPath).readAsBytes();
    // base64String = base64Encode(fileBytes);
    // language can set ("華語", "台語", "華台雙語", "客語", "英語", "印尼語", "粵語")

    Map<String, String> language2ServiceID = {
      "華語": "A017",
      "台語": "A018",
      "華台雙語": "A019",
      "客語": "A020",
      "英語": "A021",
      "印尼語": "A022",
      "粵語": "A023"
    };

    final response = await http.post(
      Uri.parse('http://140.116.245.149:2802/asr'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "audio_data": base64String,
        "token": token,
        "service_id": language2ServiceID[language]!,
        "audio_format": "wav"
      }),
    );

    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      String sentence = resultMap['words_list'][0];
      return sentence;
    }
    else {
      print(response.statusCode.toString());
      throw Exception('Failed to request server.');
    }
  }
}
