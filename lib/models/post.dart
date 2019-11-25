import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// example on how to fetch data from http call and create a list

List<Post> list = List();
Future<List<Post>> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/photos');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    list = (json.decode(response.body) as List)
        .map((data) => new Post.fromJson(data))
        .toList();
    print(list[0].title);
    print(list[1].title);
    return list;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
