import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../provider/saved.provider.dart';
import '../model/trending_model.dart';
import 'package:provider/provider.dart';
import '../components/saved_news_item.dart';
import '../provider/setting.provider.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {

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
      appBar: CustomAppBar(title: "Saved"),
      body: Consumer<SavedProvider>(
        builder: (context, savedProvider, child) {
          final List<TrendingModel> newsList = savedProvider.getList;
          final String order=savedProvider.sort;

          // Check if the list is empty and display appropriate content
          if (newsList.isEmpty) {
            return const Center(
              child: Text(
                "No Saved News Found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        savedProvider.setSort("asc");
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
                        savedProvider.setSort("desc");
                      }, child:  Icon(
                    Icons.arrow_downward, // Use your preferred icon
                    size: 20.0,
                    color:order=='desc'? getOppositeColor(settingsProvider.appBarColor): settingsProvider.appBarColor, // Adjust color if needed
                  ))
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final newsItem = newsList[index];
                    return SavedNewsItem(newsItem: newsItem,onDelete:(){
                      savedProvider.removeItem(index);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("News Deleted!",style: TextStyle(
                            fontSize: 25,
                            color: Colors.white
                        ),),
                            backgroundColor: Colors.red, // Set the background color
                            duration: const Duration(seconds: 2)),
                      );

                    });
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
