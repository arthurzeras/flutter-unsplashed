import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreenWidget extends StatefulWidget {
  HomeScreenWidget({ Key key }) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  Future<List> images;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<List<UnsplashImage>> _getImages(String query) async {
    final response = 
      await http.get("https://unsplash.com/napi/search?query=$query&per_page=20");

    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      
      return (decoded['photos']['results'] as List)
        .map((item) => UnsplashImage.fromJson(item['urls']['small']))
        .toList();
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
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
                        setState(() { images = _getImages(_valueController.text); });
                        // setState(() { post = fetchPost(_valueController.text); });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: images,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      snapshot.data[index].image,
                      fit: BoxFit.cover,
                    );
                  },
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }
}

class UnsplashImage {
  final String image;
  
  UnsplashImage({ this.image });

  factory UnsplashImage.fromJson(String json) {
    return UnsplashImage(image: json.toString());
  }
}