import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://newsapi.org/v2';
  // https://newsapi.org/v2/top-headlines?country=us&apiKey=8ba439a26c554d0abf386b4115a089fb
  static Future<http.Response> get(String endpoint,String query) async {
    print(query);
    final response = await http.get(Uri.parse('$baseUrl/$endpoint$query'));
    return response;
  }
}
