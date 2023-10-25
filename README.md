# VoiceToText

The `VoiceToText` class is a Dart class that provides functionality for speech recognition using the `speech_to_text` library. It allows to initialize speech recognition, start listening, stop listening and provide speech recognition results. Here is the detailed documentation of the class:

## Constructors

`VoiceToText({int? stopFor})`
Constructor of the Speech class. It can accept an optional `stopFor` parameter representing the duration in seconds before stopping the recognition from the last spoken word. default value is 5 seconds.

## Methods

`initSpeech() -> void`.

Initializes speech recognition.

`startListening() -> void`

Starts listening to the user's speech.

`stop() -> void`

Stops the active listener.

`addListener(VoidCallback listener) -> void`

Adds a `listener` to the listener list to be notified when the listener state changes.

`notifyListeners() -> void`

Notifies all registered listeners when the listener state changes.

`get speechEnabled -> bool`

Returns a boolean value indicating whether speech recognition is enabled on the device.

`get isListening -> bool`

Returns a boolean value indicating whether speech recognition is currently in progress.

`get isNotListening -> bool`

Returns a boolean value indicating whether speech recognition is not in process, i.e. is stopped.

`get speechResult -> String`

Returns the text recognized during active listening.

## Example

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
## Permissions 
Applications using this plugin require user permissions.

### iOS
Add the following keys to your `Info.plist` file, located in `<project root>/ios/Runner/Info.plist:`

- `NSSpeechRecognitionUsageDescription` - describe why your app uses speech recognition. This is called *Privacy - Speech Recognition* Usage Description in the visual editor.
- `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone. This is called Privacy - Microphone Usage Description in the visual editor.
### Android 
Add the record audio permission to your `AndroidManifest.xml` file, located in `<project root>/android/app/src/main/AndroidManifest.xml.`

- `android.permission.RECORD_AUDIO` - this permission is required for microphone access.
- `android.permission.INTERNET` - this permission is required because speech recognition may use remote services.
- `android.permission.BLUETOOTH` - this permission is required because speech recognition can use bluetooth headsets when connected.
- `android.permission.BLUETOOTH_ADMIN` - this permission is required because speech recognition can use bluetooth headsets when connected.
- `android.permission.BLUETOOTH_CONNECT` - this permission is required because speech recognition can use bluetooth headsets when connected.
```xml
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.BLUETOOTH"/>
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
```
## Android SDK Version Error When Compiling

The speech_to_text plugin requires Android SDK version 21 or higher due to the utilization of speech functions introduced in that version of Android. To resolve this error, update the `build.gradle` file as follows:

```gradle
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 21
        targetSdkVersion 28
        ...
    }
}
```

Ensure that the `minSdkVersion` in your `build.gradle` is set to 21 or a higher version to successfully compile the project.
## Documentation of speech_to_text
This package has been developed using the speech_to_text library as a base. If you are interested in learning more about this library, visit to
[speech_to_text.](https://pub.dev/packages/speech_to_text)