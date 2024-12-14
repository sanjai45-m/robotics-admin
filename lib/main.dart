import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jkv/controller/theme_provider.dart';
import 'package:jkv/controller/workshop_data.dart';
import 'package:jkv/view/form/worshops.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyAEtOExKy6kpd2xUg72x6Zrl_4cpm4AV_0",
      appId: "1:419020799007:android:4cb0178f867d6eca91292a",
      messagingSenderId: "419020799007",
      projectId: "snews-8ed67",
  storageBucket: "gs://snews-8ed67.appspot.com"));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => WorkshopDataProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, ThemeProvider themeProvider, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode, // Use themeMode from ThemeProvider
          home: const WorkShops(),
        );
      },
    );
  }
}


