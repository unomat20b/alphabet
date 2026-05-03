import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// POST в тот же endpoint, что и сайт IntellectShop (`/api-feedback`).
///
/// В веб-сборке используем [Uri.base.origin] + `/api-feedback` — явный
/// абсолютный URL в корне сайта (как у `curl …/api-feedback`).
Uri _feedbackEndpoint() {
  if (kIsWeb) {
    final origin = Uri.base.origin;
    if (origin.isEmpty) {
      return Uri.parse('https://intellectshop.net/api-feedback');
    }
    return Uri.parse('$origin/api-feedback');
  }
  return Uri.parse('https://intellectshop.net/api-feedback');
}

class FeedbackSubmitResult {
  final bool ok;
  final String? message;
  const FeedbackSubmitResult.ok() : ok = true, message = null;
  const FeedbackSubmitResult.fail(this.message) : ok = false;
}

class FeedbackApi {
  /// [name] может быть пустым — на сервер уйдёт дефис для NOT NULL полей.
  static Future<FeedbackSubmitResult> submit({
    required String name,
    required String email,
    required String message,
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final trimmedMessage = message.trim();

    try {
      final request = http.MultipartRequest('POST', _feedbackEndpoint());
      request.headers['Cache-Control'] = 'no-cache';
      request.fields['name'] = trimmedName.isEmpty ? '-' : trimmedName;
      request.fields['email'] = trimmedEmail;
      request.fields['message'] = trimmedMessage;
      request.fields['source'] = 'alphabet';
      request.fields['tag'] = 'alphabet';

      final streamed = await request.send().timeout(
            const Duration(seconds: 25),
          );
      final body = await streamed.stream.bytesToString();
      final code = streamed.statusCode;

      if (code < 200 || code >= 300) {
        return FeedbackSubmitResult.fail('http_$code');
      }

      final trimmed = body.trim();
      if (trimmed.isEmpty) {
        return const FeedbackSubmitResult.ok();
      }

      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map) {
          final success = decoded['success'];
          if (success == false) {
            final err = decoded['error']?.toString() ?? 'server';
            return FeedbackSubmitResult.fail(err);
          }
        }
      } catch (_) {
        // не JSON — считаем успехом при 2xx
      }
      return const FeedbackSubmitResult.ok();
    } catch (e) {
      return FeedbackSubmitResult.fail(e.toString());
    }
  }
}
