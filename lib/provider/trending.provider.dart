import 'package:flutter/material.dart';
import '../model/trending_model.dart';
import '../controller/trending_controller.dart';
import 'package:intl/intl.dart';
import '../provider/setting.provider.dart';

class TrendingProvider with ChangeNotifier {
    final SettingsProvider settingsProvider;
    TrendingProvider(this.settingsProvider);

    DateTime? _from;
    DateTime? _to;
    String order = "";
    List<TrendingModel> _list = [];
    String _category = "Other";
    String _sort="asc";

    List<TrendingModel> get items => _list;
    DateTime? get from => _from;
    DateTime? get to => _to;
    String get category => _category;
    String get sort=>_sort;

    final TrendingController _controller = TrendingController();
    Future<void> loadItems() async {
        try {
            String? formattedFromDate;
            String? formattedToDate;
            final dateFormat = DateFormat('yyyy-MM-dd');

            if (_from != null) {
                formattedFromDate = dateFormat.format(_from!);
            }
            if (_to != null) {
                formattedToDate = dateFormat.format(_to!);
            }

            _list = await _controller.getTrendingNews(
                _category == "Other" ? "" : _category,
                settingsProvider.country

            );

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
    void clearDates() {
        _from = null;
        _to = null;
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
