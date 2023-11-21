# Simple example to voice_to_text 
```dart
import 'package:flutter/material.dart';
import 'package:voice_to_text/voice_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: SpeechDemo(),
    );
  }
}

class SpeechDemo extends StatefulWidget {
  const SpeechDemo({Key? key}) : super(key: key);

  @override
  State<SpeechDemo> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SpeechDemo> {
  final VoiceToText _speech = VoiceToText();
  String text = ""; //this is optional, I could get the text directly using speechResult
  @override
  void initState() {
    super.initState();
    _speech.initSpeech();
    _speech.addListener(() {
      setState(() {
        text = _speech.speechResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Demo'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(
                _speech.isListening
                    ? "Listening...."
                    : 'Tap the microphone to start',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(_speech.isNotListening
                ? text.isNotEmpty
                    ? text
                    : "Try speaking again"
                : ""),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speech.isNotListening ? _speech.startListening : _speech.stop,
        tooltip: 'Listen',
        child: Icon(_speech.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}

```
