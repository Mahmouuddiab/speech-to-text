import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText speechToText = SpeechToText();

  Future<bool> initialize({
    Function(String)? onStatus,
    Function(dynamic)? onError,
  }) async {
    return await speechToText.initialize(
      onStatus: onStatus,
      onError: onError,
    );
  }

  Future<void> startListening({
    required Function(SpeechRecognitionResult) onResult,
  }) async {
    await speechToText.listen(
      onResult: onResult,
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 10),
      partialResults: true,
      localeId: "en_US",
    );
  }

  Future<void> stopListening() async {
    await speechToText.stop();
  }

  bool get isListening => speechToText.isListening;

  bool get isNotListening => speechToText.isNotListening;

  Future<bool> get hasPermission async =>
      await speechToText.hasPermission;

  Future<List<LocaleName>> getLocales() async {
    return await speechToText.locales();
  }
}