import '../services/trending_service.dart';
import '../model/trending_model.dart';

class TrendingController{
  Future<List<TrendingModel>> getTrendingNews(String query,String language) async{
    try{
      return await TrendingService.fetchTrendingNews(query,language);
    }catch (e){
      rethrow;
    }
  }
}