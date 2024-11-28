import '../services/news_service.dart';
import '../model/trending_model.dart';

class NewsController{
  Future<List<TrendingModel>> getNews(String category,String? fromDate,String? toDate,String language) async{
    try{
      return await NewsService.fetchNews(category,fromDate,toDate,language);
    }catch (e){
      rethrow;
    }
  }
}
