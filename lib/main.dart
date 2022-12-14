import 'package:flutter/material.dart';
import 'package:pagination_demo/model/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        image: Icon(Icons.add),
        // name: 'Shah',
        // message: 'This is a personal message',
      ),
    );
  }
}
