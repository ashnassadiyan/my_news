import 'package:flutter/material.dart';
import '../model/trending_model.dart';

class SavedProvider with ChangeNotifier{

  List<TrendingModel> _list = [];
  String _sort="asc";

  List<TrendingModel> get getList => _list;
  String get sort=>_sort;

  void removeItem(int index) {
    _list.removeAt(index);
    notifyListeners();
  }

  void addToList(TrendingModel item){
    _list.add(item);
    notifyListeners();
  }

  void loadItems(){
    sortItems(_sort);
    notifyListeners();
  }

  void setSort(String sortType){
    _sort=sortType;
    sortItems(sortType);
    notifyListeners();
  }

  void sortItems(String sortType) {
    if (sortType == "asc") {
      _list.sort((a, b) {
        DateTime? dateA = DateTime.tryParse(a.publishedAt ?? '');
        DateTime? dateB = DateTime.tryParse(b.publishedAt ?? '');
        return dateA?.compareTo(dateB ?? DateTime.now()) ?? 0;
      });
    } else {
      _list.sort((a, b) {
        DateTime? dateA = DateTime.tryParse(a.publishedAt ?? '');
        DateTime? dateB = DateTime.tryParse(b.publishedAt ?? '');
        return dateB?.compareTo(dateA ?? DateTime.now()) ?? 0;
      });
    }
  }



}