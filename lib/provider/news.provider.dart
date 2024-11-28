import 'package:flutter/material.dart';
import '../model/trending_model.dart';
import '../controller/news_controller.dart';
import 'package:intl/intl.dart';
import '../provider/setting.provider.dart';
import 'package:provider/provider.dart';

class NewsProvider with ChangeNotifier{
final SettingsProvider settingsProvider;


NewsProvider(this.settingsProvider);
    DateTime? _from;
    DateTime? _to;
    List<TrendingModel> _list=[];
    String _category="Weather";
    String _sort="asc";

    List<TrendingModel> get items => _list;
    String get category => _category;
    DateTime? get from => _from;
    DateTime? get to => _to;
    String get sort=>_sort;

final NewsController _controller= NewsController();
Future<void> loadItems() async {
    try {
        String? formattedFromDate;
        String? formattedToDate;

        final dateFormat = DateFormat('yyyy-MM-dd');

        if (from != null) {
            formattedFromDate = dateFormat.format(from!);
        }
        if (to != null) {
            formattedToDate = dateFormat.format(to!);
        }

        _list = await _controller.getNews(_category ?? "",formattedFromDate,formattedToDate,settingsProvider.country);
        sortItems(_sort);
        notifyListeners();
    } catch (e) {
        print('Error loading items: $e');
    }
}

void setCategory(String newCategory) {
    _category = newCategory;
    loadItems();
    notifyListeners();
}

void setDates(DateTime fromDate, DateTime toDate) {
    _from = fromDate;
    _to = toDate;
    loadItems();
    notifyListeners();
}

void clearDates(){
    _from=null;
    _to=null;
    loadItems();
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