import 'dart:ui';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// The `VoiceToText` class provides functionality for converting speech to text using the `speech_to_text` package.
class VoiceToText {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String textResult = '';
  int _stop = 0;
  final List<VoidCallback> _listeners = [];

  /// Creates an instance of `VoiceToText`.
  ///
  /// The optional parameter `stopFor` specifies the duration (in seconds) to pause after speech recognition stops.
  VoiceToText({int? stopFor}) {
    _stop = stopFor ?? 4;
  }

  /// Initializes the speech recognition engine.
  ///
  /// Must be called before using other methods.
  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Starts listening for speech input.
  ///
  /// Recognized words are provided through the [onResult] callback.
  /// Pauses for the duration specified during initialization.
  void startListening() async {
    textResult = "";
    await _speechToText.listen(
        onResult: _onSpeechResult, pauseFor: Duration(seconds: _stop));
    Future.delayed(Duration(seconds: _stop + 1), _status);
    notifyListeners();
  }

  /// Stops the speech recognition process.
  void stop() async {
    await _speechToText.stop();
    notifyListeners();
  }

  /// Callback for handling speech recognition results.
  void _onSpeechResult(SpeechRecognitionResult result) {
    textResult = result.recognizedWords;
    if (isNotListening) {
      stop();
    }
  }

  /// Adds a listener to be notified when the state of the speech recognition changes.
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Notifies all registered listeners.
  void notifyListeners() {
    for (var element in _listeners) {
      element();
    }
  }

  /// Checks the status of the speech recognition and stops if it's done and no speech is recognized.
  void _status() {
    if (_speechToText.lastStatus == "done" && speechResult == "") {
      stop();
    }
  }

  /// Indicates whether speech recognition is enabled.
  bool get speechEnabled => _speechEnabled;

  /// Indicates whether the speech recognition is currently in progress.
  bool get isListening => _speechToText.isListening;

  /// Indicates whether the speech recognition is not currently in progress.
  bool get isNotListening => !_speechToText.isListening;

  /// Gets the recognized speech result.
  String get speechResult => textResult;
}
