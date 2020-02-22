import 'package:flutter/material.dart';
import 'package:linkify_text/linkify_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LinkifyText(
          "please visit google.com",
          fontSize: 15.0,
          linkColor: Colors.blue,
          textColor: Colors.black,
          fontWeight: FontWeight.w500,
          isLinkNavigationEnable:
              true, //By Default it is true. If it is false, user would not navigate to the link on tapping
        ),
      ),
    );
  }
}
