import 'dart:convert';
import 'api_client.dart';
import '../model/trending_model.dart';

class NewsService {
  static Future<List<TrendingModel>> fetchNews(String category,String? fromDate,String? toDate,String language) async {
    final response = await ApiClient.get('everything',"?apiKey=8ba439a26c554d0abf386b4115a089fb&q=$category&from=$fromDate&to=$toDate&language=$language");

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
