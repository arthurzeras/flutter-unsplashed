import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String _title = 'Unsplashed';

    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primaryColor: Colors.grey[900]
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_title)
        ),
        body: HomeScreenWidget()
      ),
    );
  }
}
