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
  Future<List> images;
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<List<UnsplashImage>> _getImages(String query) async {
    setState(() { _loading = true; });

    final response = 
      await http.get("https://unsplash.com/napi/search?query=$query&per_page=20");

    setState(() { _loading = false; });

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
              if (_loading) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              
              if (snapshot.hasData) {
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

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    'https://bit.ly/30XTjBZ'
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Type a term like cars, universe, dogs and others above',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              );
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