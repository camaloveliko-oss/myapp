import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// One place for all Tochka backend calls. The UI can be developed against
/// these contracts now and the real provider keys can be supplied later.
class BusinessApiService {
  BusinessApiService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<Map<String, dynamic>> analyzeLocation({
    required String city,
    required String businessType,
    String address = '',
  }) async {
    return _post('/analysis/location', {
      'city': city,
      'business_type': businessType,
      'address': address,
    });
  }

  Future<Map<String, dynamic>> analyze2GisLocation({
    required String city,
    required String businessType,
    String address = '',
  }) {
    return analyzeLocation(
      city: city,
      businessType: businessType,
      address: address,
    );
  }

  Future<Map<String, dynamic>> calculateRoi({
    required double rent,
    required double averageTicket,
    double margin = .35,
  }) async {
    return _post('/analysis/roi', {
      'rent': rent,
      'average_ticket': averageTicket,
      'margin': margin,
    });
  }

  Future<Map<String, dynamic>> generateNegotiationText({required String address, required List<String> risks}) async {
    return _post('/analysis/negotiate', {'address': address, 'risks': risks});
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: {'Content-Type': 'application/json', if (ApiConfig.hasAiKey) 'Authorization': 'Bearer ${ApiConfig.aiApiKey}'},
      body: jsonEncode(body),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API ${response.statusCode}: ${response.body}');
    }
    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
  }
}
