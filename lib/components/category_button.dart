import 'package:flutter/material.dart';
import '../provider/news.provider.dart';
import '../provider/setting.provider.dart';
import 'package:provider/provider.dart';

class CategoryButton extends StatelessWidget {
  final String category;
  final String selectedCategory;
  final NewsProvider newsProvider;

  const CategoryButton({
    Key? key,
    required this.category,
    required this.selectedCategory,
    required this.newsProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = category == selectedCategory;
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? settingsProvider.appBarColor : null,
        foregroundColor: isSelected ? Colors.white : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
          minimumSize: const Size(50, 40),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
      ),
      onPressed: () {
        newsProvider.setCategory(category);
      },
      child: Text(category),
    );
  }
}
