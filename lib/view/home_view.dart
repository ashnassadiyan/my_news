import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../provider/trending.provider.dart';
import '../provider/news.provider.dart'; // Ensure this import is correct
import 'package:provider/provider.dart';
import '../model/trending_model.dart';
import '../view/view_news_view.dart';
import '../components/trending_news_item.dart'; // Fixed missing semicolon

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Home"),
      body: Consumer2<TrendingProvider, NewsProvider>(
        builder: (context, trendingProvider, newsProvider, child) {
          final List<TrendingModel> newsList = newsProvider.items;
          return Column(
            children: [
              trendingProvider.items.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : buildTrendingCarousel(trendingProvider),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "News For You",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

  // Build the carousel slider
  Widget buildTrendingCarousel(TrendingProvider trendingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        CarouselSlider.builder(
          itemCount: trendingProvider.items.length,
          itemBuilder: (context, index, realIndex) {
            final res = trendingProvider.items[index];
            return buildImage(res.urlToImage, res.title, res);
          },
          options: CarouselOptions(
            height: 250.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 6),
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            viewportFraction: 0.8,
          ),
        ),
      ],
    );
  }

  // Handle null or empty images gracefully
  Widget buildImage(String? image, String? title, TrendingModel data) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ViewNewsView(newsData: data)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image != null && image.isNotEmpty
                  ? Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              )
                  : const Icon(Icons.broken_image, size: 100, color: Colors.grey),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  title ?? "Loading",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
