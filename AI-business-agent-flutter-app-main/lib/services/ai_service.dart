import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AiService {
  late String _authToken;

  AiService({String? authToken}) {
    _authToken = authToken ?? '';
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  Future<String> generateResponse(
    String prompt, {
    Map<String, dynamic>? locationContext,
  }) async {
    final normalizedPrompt = prompt.trim();
    if (normalizedPrompt.isEmpty) {
      return 'Please enter a request for the AI assistant.';
    }

    try {
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (_authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $_authToken';
      }
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/chat'),
        headers: headers,
        body: jsonEncode({
          'prompt': normalizedPrompt,
          if (locationContext != null) 'location_context': locationContext,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded['message']?.toString() ??
              decoded['response']?.toString() ??
              'No response received.';
        }
        return decoded.toString();
      } else if (response.statusCode == 401) {
        return 'Session expired. Please login again.';
      }
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final message = decoded['message']?.toString();
          final error = decoded['error']?.toString();
          if (message != null && message.isNotEmpty) {
            return error == null || error.isEmpty
                ? message
                : '$message: $error';
          }
        }
      } catch (_) {
        // Fall through to the status code when the server did not return JSON.
      }
      return 'AI server xətası (${response.statusCode})';
    } catch (e) {
      return 'AI serverə qoşulmaq mümkün olmadı: $e';
    }
  }
}
