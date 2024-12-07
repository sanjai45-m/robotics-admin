import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>WorkshopDataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        home: const WorkShops(),
      ),
    );
  }
}

