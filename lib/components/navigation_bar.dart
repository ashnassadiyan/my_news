import 'package:flutter/material.dart';
import 'package:my_news/view/home_view.dart';
import 'package:my_news/view/saved_view.dart';
import 'package:my_news/view/settings_view.dart';
import 'package:my_news/view/trending.dart';
import 'package:my_news/view/news_view.dart';
import '../provider/setting.provider.dart';
import 'package:provider/provider.dart';

class NavigationMenuBar extends StatefulWidget {
  const NavigationMenuBar({Key? key}) : super(key: key);

  @override
  State<NavigationMenuBar> createState() => _NavigationMenuBarState();
}

class _NavigationMenuBarState extends State<NavigationMenuBar> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
       HomeView(),
       NewsView(),
       TrendingView(),
       SavedView(),
       SettingsView(),
    ];

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);



    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.white,
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
                (states) => states.contains(MaterialState.selected)
                ? IconThemeData(color:settingsProvider.appBarColor)
                : const IconThemeData(color: Colors.grey),
          ),

        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          height: 60,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.newspaper),
              label: 'News',
            ),
            NavigationDestination(
              icon: Icon(Icons.apps_outage_outlined),
              label: 'Trending',
            ),
            NavigationDestination(
              icon: Icon(Icons.save),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
