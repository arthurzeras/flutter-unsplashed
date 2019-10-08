import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = 'Unsplashed';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primaryColor: Colors.grey[900]
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title)
        ),
        body: Center(
          child: Image.network('https://picsum.photos/250?image=9'),
        )
      ),
    );
  }
}
