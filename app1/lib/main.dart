import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Henshin App'),
      ),
      body: Center(
        child: Text(
          'Henshin',
          style: TextStyle(
            fontFamily: 'IndieFlower',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: Colors.blueAccent,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    ),
  ));
}