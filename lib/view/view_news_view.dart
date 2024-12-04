import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../model/trending_model.dart';
import '../provider/setting.provider.dart';
import '../provider/saved.provider.dart';
import 'package:provider/provider.dart';

class ViewNewsView extends StatefulWidget {
  final TrendingModel newsData;

  const ViewNewsView({super.key, required this.newsData});

  @override
  State<ViewNewsView> createState() => _ViewNewsView();
}

class _ViewNewsView extends State<ViewNewsView> {
  @override
  Widget build(BuildContext context) {
    final saveProvider = Provider.of<SavedProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: "News"),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: widget.newsData.urlToImage != null &&
                      widget.newsData.urlToImage!.isNotEmpty
                      ? Image.network(
                    widget.newsData.urlToImage!,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  )
                      : const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
                Positioned(
                  top: 3,
                  right: 1,
                  child: IconButton(
                    onPressed: () {
                      saveProvider.addToList(widget.newsData);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("News saved!",style: TextStyle(
                          fontSize: 25,
                          color: Colors.white
                        ),),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2)),
                      );
                    },
                    icon: Icon(
                      Icons.save,
                      size: 30,
                      color: settingsProvider.appBarColor,
                    ),
                    tooltip: 'Favorite',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.newsData.title ?? 'No Title Available',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.newsData.description ?? 'No Description Available',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
