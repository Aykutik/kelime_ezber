import 'package:flutter/material.dart';
import 'package:kelime_ezber/sayfalar/baslangicekrani/baslangicekrani.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: baslangicekrani(),
    );
  }
}
