import 'dart:convert';
import 'api_client.dart';
import '../model/trending_model.dart';

class TrendingService {
  static Future<List<TrendingModel>> fetchTrendingNews(String query, String language) async {
    final response = await ApiClient.get('top-headlines','?country=us&q=$query&apiKey=8ba439a26c554d0abf386b4115a089fb&language=$language');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> articles = jsonData['articles'];
      final List<TrendingModel> data = articles.map((item) => TrendingModel.fromJson(item)).toList();
      return data;
    } else {
      throw Exception('Failed to load items');
    }
  }
}
