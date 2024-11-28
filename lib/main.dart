import 'package:flutter/material.dart';
import 'package:my_news/components/navigation_bar.dart';
import 'package:my_news/provider/setting.provider.dart';
import 'package:my_news/provider/trending.provider.dart';
import 'package:my_news/provider/news.provider.dart';
import 'package:my_news/provider/saved.provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, TrendingProvider>(
          create: (context) =>
              TrendingProvider(context.read<SettingsProvider>()),
          update: (_, settingsProvider, previousTrendingProvider) =>
          previousTrendingProvider ?? TrendingProvider(settingsProvider),
        ),
        ChangeNotifierProxyProvider<SettingsProvider, NewsProvider>(
          create: (context) => NewsProvider(context.read<SettingsProvider>()),
          update: (_, settingsProvider, previousNewsProvider) =>
          previousNewsProvider ?? NewsProvider(settingsProvider),
        ),
        ChangeNotifierProvider(create: (_) => SavedProvider()),
      ],
      child: MyApp(),
  ),);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final trendingProvider = Provider.of<TrendingProvider>(context, listen: false);
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    trendingProvider.loadItems();
    newsProvider.loadItems();
  }

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
  );

  final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home:Scaffold(
            bottomNavigationBar:NavigationMenuBar()
        ),
      theme: settingsProvider.appMode=="light"?lightTheme:darkTheme,
    );
  }
}

