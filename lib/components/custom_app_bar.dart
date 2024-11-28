import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/setting.provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color titleColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = Colors.blue,
    this.titleColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final settingsProvider = Provider.of<SettingsProvider>(context);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: settingsProvider.appBarColor,
      iconTheme: IconThemeData(color: titleColor),
      elevation: 0, // Optional: remove shadow
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
