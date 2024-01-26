import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _search;
  int _offset = 0;

  Future<Map<String, dynamic>> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=aS7QKRwUHahQFoyFfjUpRRbUFDn3Bg0r&limit=20&offset=0&rating=g&bundle=messaging_non_clips'));
    } else {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=aS7QKRwUHahQFoyFfjUpRRbUFDn3Bg0r&q=$_search&limit=19&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips'));
    }

    return json.decode(response.body);
  }

  //inicia quando a aplicação abre
  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
                labelText: 'Pesquise aqui',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()),
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
            onSubmitted: (text) {
              setState(() {
                _search = text;
                _offset = 0;
              });
            },
          ),
        ),
        Expanded(
            child: FutureBuilder(
          future: _getGifs(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Container(
                    width: 200,
                    height: 2000,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5,
                    ));
              default:
                if (snapshot.hasError)
                  return Container();
                else
                  return _createGiftTable(context, snapshot);
            }
          },
        ))
      ]),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGiftTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: _getCount(snapshot.data['data']),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data['data'].length) {
            return GestureDetector(
              child: Image.network(
                snapshot.data['data'][index]['images']['fixed_height']['url'],
                height: 300,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      'Carregar mais...',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
          }
        });
  }
}
