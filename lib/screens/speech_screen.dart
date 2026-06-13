import 'package:flutter/material.dart';
import 'package:speech_text/service/speech_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final SpeechService _speechService = SpeechService();

  bool _speechEnabled = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    _speechEnabled = await _speechService.initialize(
      onStatus: (status) => debugPrint("STATUS: $status"),
      onError: (error) => debugPrint("ERROR: $error"),
    );

    debugPrint("Speech Enabled: $_speechEnabled");
    debugPrint(
      "Permission: ${await _speechService.hasPermission}",
    );

    final locales = await _speechService.getLocales();
    debugPrint("Locales Found: ${locales.length}");

    setState(() {});
  }

  Future<void> _startListening() async {
    await _speechService.startListening(
      onResult: _onSpeechResult,
    );

    setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechService.stopListening();

    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _recognizedText = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Speech Recognition',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _speechService.isListening
                  ? 'Listening...'
                  : 'Ready to transcribe your voice',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _speechService.isListening
                        ? (_recognizedText.isEmpty
                        ? 'Start speaking...'
                        : _recognizedText)
                        : _speechEnabled
                        ? (_recognizedText.isEmpty
                        ? 'Tap the microphone to start listening'
                        : _recognizedText)
                        : 'Speech recognition unavailable',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: _recognizedText.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: _speechService.isListening
                    ? Colors.red.withOpacity(.1)
                    : Colors.green.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _speechService.isListening
                        ? Icons.mic
                        : Icons.check_circle_outline,
                    color: _speechService.isListening
                        ? Colors.red
                        : Colors.green,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _speechService.isListening
                        ? 'Recording in progress'
                        : 'Ready to record',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechService.isNotListening
            ? _startListening
            : _stopListening,
        child: Icon(
          _speechService.isNotListening
              ? Icons.mic_off
              : Icons.mic,
        ),
      ),
    );
  }
}