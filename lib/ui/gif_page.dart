import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData); //construtor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _gifData['title'],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Image.network(_gifData['images']['fixed_height']['url'])),
    );
  }
}
