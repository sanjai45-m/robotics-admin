import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/theme_provider.dart';
import '../../model/drawers.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(drawer: const Drawers(activePage: "Settings",),
      appBar: AppBar(
        title: Text("settings"),
      ),
    body: Center(
    child: SwitchListTile(
    title: const Text('Enable Dark Theme'),
    value: themeProvider.themeMode == ThemeMode.dark,
    onChanged: (value) {
    themeProvider.toggleTheme();
    },
    ),
    ));
  }
}
