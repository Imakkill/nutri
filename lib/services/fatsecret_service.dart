import 'package:http/http.dart' as http;
import 'dart:convert';

class FatSecretService {
  final String clientId = '8e4b8af6ed0c496ea9bb8a86f80a6948';
  final String clientSecret = 'f9e52eba9b0245ac825d5bcce4ddf9b5';

  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://oauth.fatsecret.com/connect/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
        'scope': 'basic',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['access_token'];
    } else {
      throw Exception('Falha ao obter o token de acesso');
    }
  }

  Future<List<dynamic>> searchFoods(String query) async {
    final token = await getAccessToken();

    final response = await http.get(
      Uri.parse(
          'https://platform.fatsecret.com/rest/server.api?method=foods.search&search_expression=$query&format=json'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['foods']['food'];
    } else {
      throw Exception('Falha ao buscar alimentos');
    }
  }
}
