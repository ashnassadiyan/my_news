import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_app_bar.dart';
import 'package:my_news/provider/trending.provider.dart';
import 'package:my_news/provider/setting.provider.dart';
import 'package:my_news/model/trending_model.dart';
import 'package:my_news/components/trending_news_item.dart';
import '../components/category_trending_button.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({super.key});

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(TrendingProvider trendingProvider) {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      print("Searching for: $query");
      trendingProvider.setCategory(query);
    }
  }

  Color getOppositeColor(Color color) {
    return Color.fromARGB(
      color.alpha, // Preserve the original alpha value
      255 - color.red,
      255 - color.green,
      255 - color.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final trendingProvider = Provider.of<TrendingProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final String selected = trendingProvider.category;
    final String order=trendingProvider.sort;

    return Scaffold(
      appBar: CustomAppBar(title: "Trending"),
      body: Consumer<TrendingProvider>(
        builder: (context, trendingProvider, child) {
          final List<TrendingModel> newsList = trendingProvider.items;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: "Search For Trending news",
                          hintText: "Search For Trending news",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onSubmitted: (value) => _onSearch(
                          Provider.of<TrendingProvider>(context, listen: false),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: settingsProvider.appBarColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(50, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      onPressed: () {
                        // .setCategory(_searchController.text);
                      },
                      child: const Text("Search"),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: settingsProvider.appMode=="light"?Colors.white :Colors.black ,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(50, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      onPressed: (){
                        trendingProvider.setSort("asc");
                      },
                      child:  Icon(
                        Icons.arrow_upward,
                        size: 20.0,
                        color:order=='asc'? getOppositeColor(settingsProvider.appBarColor): settingsProvider.appBarColor,
                      )),
                  SizedBox(width: 3.0,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: settingsProvider.appMode=="light"?Colors.white :Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(50, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      onPressed: (){
                        trendingProvider.setSort("desc");
                      }, child:  Icon(
                    Icons.arrow_downward, // Use your preferred icon
                    size: 20.0,
                    color:order=='desc'? getOppositeColor(settingsProvider.appBarColor): settingsProvider.appBarColor, // Adjust color if needed
                  ))
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryButton(
                      category: "Weather",
                      selectedCategory: selected,
                      trendingProvider: trendingProvider,
                    ),
                    const SizedBox(width: 10),
                    CategoryButton(
                      category: "Sports",
                      selectedCategory: selected,
                      trendingProvider: trendingProvider,
                    ),
                    const SizedBox(width: 10),
                    CategoryButton(
                      category: "Political",
                      selectedCategory: selected,
                      trendingProvider: trendingProvider,
                    ),
                    const SizedBox(width: 10),
                    CategoryButton(
                      category: "Tech",
                      selectedCategory: selected,
                      trendingProvider: trendingProvider,
                    ),
                    const SizedBox(width: 10),
                    CategoryButton(
                      category: "Other",
                      selectedCategory: selected,
                      trendingProvider: trendingProvider,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: newsList.isEmpty
                    ? Center(
                  child: Text(
                    "No Trending news found",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final newsItem = newsList[index];
                    return TrendingNewsItem(newsItem: newsItem);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
