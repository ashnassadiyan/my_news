import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../provider/setting.provider.dart';
import '../components/custom_app_bar.dart';
import '../provider/news.provider.dart';
import '../provider/trending.provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late Color _selectedColor;
  late bool isDarkTheme;
  final List<String> countries = [
    "en",
    "ar",
    "de",
    "es",
    "fr",
    "he",
    "it",
    "nl",
    "no",
    "ru",
    "sv",
    "ud",
    "zh"
  ];

  @override
  void initState() {
    super.initState();
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _selectedColor = settingsProvider.appBarColor ?? Colors.blue;
    isDarkTheme = settingsProvider.appMode == 'dark';
  }

  void _openColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.7,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Provider.of<SettingsProvider>(context, listen: false)
                    .setAppBarColor(_selectedColor);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final newsProvider = Provider.of<NewsProvider>(context);
    final trendingProvider = Provider.of<TrendingProvider>(context);
    final String selectedCountry =settingsProvider.country;

    return Scaffold(
      appBar: CustomAppBar(title: "Settings"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar Color Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("App Bar Color:"),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: _openColorPickerDialog,
                  child: const Text("Pick Color"),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // App Mode Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("App Mode:"),
                const SizedBox(width: 20),
                Switch(
                  value: isDarkTheme,
                  onChanged: (bool value) {
                    setState(() {
                      isDarkTheme = value;
                      settingsProvider.setAppMode(
                          isDarkTheme ? 'dark' : 'light');
                    });
                  },
                ),
                Text(isDarkTheme ? "Dark Mode" : "Light Mode"),
              ],
            ),
            const SizedBox(height: 40),
            // Country Selection Dropdown
            const Text(
              "Choose your country:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCountry.isEmpty ? null : selectedCountry,
              isExpanded: true,
              hint: const Text("Select a country"),
              items: countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  settingsProvider.setCountry(newValue);
                  newsProvider.loadItems();
                  trendingProvider.loadItems();
                }
              },
            ),
            const SizedBox(height: 20),
            if (selectedCountry.isNotEmpty)
              Text(
                "Selected Language: $selectedCountry",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
