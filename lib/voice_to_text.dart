import 'dart:ui';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceToText {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String textResult = '';
  int _stop = 0;
  final List<VoidCallback> _listeners = [];

  VoiceToText({int? stopFor}) {
    _stop = stopFor ?? 4;
  }
  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void startListening() async {
    textResult = "";
    await _speechToText.listen(
        onResult: _onSpeechResult, pauseFor: Duration(seconds: _stop));
    Future.delayed(Duration(seconds: _stop + 1), _status);
    notifyListeners();
  }

  void stop() async {
    await _speechToText.stop();
    notifyListeners();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    textResult = result.recognizedWords;
    if (isNotListening) {
      stop();
    }
  }

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void notifyListeners() {
    for (var element in _listeners) {
      element();
    }
  }

  void _status() {
    if (_speechToText.lastStatus == "done" && speechResult == "") {
      stop();
    }
  }

  bool get speechEnabled => _speechEnabled;

  bool get isListening => _speechToText.isListening;

  bool get isNotListening => !_speechToText.isListening;

  String get speechResult => textResult;
}
