import 'package:flutter/material.dart';

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

class HomeScreenWidget extends StatefulWidget {
  HomeScreenWidget({ Key key }) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        color: Colors.grey[800],
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _valueController,
                  style: TextStyle(color: Colors.grey[300]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search images...',
                    contentPadding: EdgeInsets.fromLTRB(0, 17, 15, 0),
                    hintStyle: TextStyle(
                      color: Colors.grey[300]
                    )
                  ),
                  validator: (value) {
                    return value.isEmpty ? 'Please enter some text' : null;
                  },
                ),
              ),
              IconButton(
                color: Colors.grey[300],
                icon: Icon(Icons.search),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print(_valueController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}