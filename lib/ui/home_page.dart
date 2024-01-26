import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _search;
  int _offset = 0;

  Future<Map<String, dynamic>> _getGifs() async {
    http.Response response;
    //final response = await http.get(Uri.parse(gifUrl));

    if (_search == null) {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=aS7QKRwUHahQFoyFfjUpRRbUFDn3Bg0r&limit=20&offset=0&rating=g&bundle=messaging_non_clips'));
    } else {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=aS7QKRwUHahQFoyFfjUpRRbUFDn3Bg0r&q=$_search&limit=20&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips'));
    }

    return json.decode(response.body);
  }

  //inicia quando a aplicação abre
  @override
  void initState() {
    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}