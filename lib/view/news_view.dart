import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_app_bar.dart';
import '../provider/setting.provider.dart';
import '../provider/news.provider.dart';
import '../components/trending_news_item.dart';
import '../model/trending_model.dart';
import '../components/category_button.dart';

class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(NewsProvider newsProvider) {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      print("Searching for: $query");
      newsProvider.setCategory(query);
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
    final settingsProvider = Provider.of<SettingsProvider>(context);


    return Scaffold(
      appBar: CustomAppBar(title: "News"),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          final List<TrendingModel> newsList = newsProvider.items;
          final String selected = newsProvider.category;
          final String order=newsProvider.sort;
          print(settingsProvider.appMode);
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
                          labelText: "Search",
                          hintText: "Search for news",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onSubmitted: (value) => _onSearch(
                          Provider.of<NewsProvider>(context, listen: false),
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
                        newsProvider.setCategory(_searchController.text);
                      },
                      child: const Text("Search"),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(newsProvider.from != null && newsProvider.to != null
                      ? "${newsProvider.from!.toLocal().toIso8601String().split('T')[0]} - ${newsProvider.to!.toLocal().toIso8601String().split('T')[0]}"
                      : "",style: TextStyle(fontSize: 12),)
                  ,
                  SizedBox(width: 6.0,),
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
                      onPressed: ()async{
                        final result=await showDateRangePicker(context: context, firstDate: DateTime(2024), lastDate: DateTime.now().add(
                          const Duration(days: 365),
                        ));

                        if(result!=null){
                          newsProvider.setDates(result.start,result.end);
                        }

                      }, child:  Icon(
                    Icons.calendar_today, // Use your preferred icon
                    size: 20.0,
                    color: settingsProvider.appBarColor, // Adjust color if needed
                  )),
                  SizedBox(width: 3.0,),
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
                        newsProvider.clearDates();
                      }, child:  Icon(
                    Icons.refresh, // Use your preferred icon
                    size: 20.0,
                    color: settingsProvider.appBarColor, // Adjust color if needed
                  )),
                  SizedBox(width: 3.0,),
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
                        newsProvider.setSort("asc");
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
                        newsProvider.setSort("desc");
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
                      newsProvider: newsProvider,
                    ),
                    const SizedBox(width: 10),
                    CategoryButton(
                      category: "Sports",
                      selectedCategory: selected,
                      newsProvider: newsProvider,
                    ),
                    const SizedBox(width: 10),
                    CategoryButton(
                      category: "Political",
                      selectedCategory: selected,
                      newsProvider: newsProvider,
                    ),
                    const SizedBox(width: 10),
                    CategoryButton(
                      category: "Tech",
                      selectedCategory: selected,
                      newsProvider: newsProvider,
                    ),
                    const SizedBox(width: 10),
                    CategoryButton(
                      category: "Other",
                      selectedCategory: selected,
                      newsProvider: newsProvider,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0,),
              Expanded(
                child: ListView.builder(
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
