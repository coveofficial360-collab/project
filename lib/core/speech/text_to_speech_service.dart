import 'package:flutter/services.dart';

class TextToSpeechService {
  TextToSpeechService._();

  static final TextToSpeechService instance = TextToSpeechService._();

  static const MethodChannel _channel = MethodChannel('cove/text_to_speech');

  Future<bool> speak(String text, {String languageCode = 'en-IN'}) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      return false;
    }

    try {
      return await _channel.invokeMethod<bool>('speak', {
            'text': cleanText,
            'languageCode': languageCode,
          }) ??
          false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stop');
    } on PlatformException {
      return;
    } on MissingPluginException {
      return;
    }
  }
}
