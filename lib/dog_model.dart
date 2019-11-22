import 'dart:convert';
import 'dart:io';
import 'dart:async';

class Dog {
  final String name;
  final String location;
  final String description;

  //non è privata
  String imageUrl;
  List<String> dogInfo;

  //non lo decidi ogni volta che istanzi una nuova classe Dog, ma è gia di default 10 per tutti i cani
  int rating = 10;

  Dog(this.name, this.location, this.description);

  Future getImageUrl() async {
    if (imageUrl != null) {
      return;
    }
    // This is how http calls are done in flutter:
    HttpClient http = HttpClient();
    try {
      // Use darts Uri builder
      var uri = Uri.http('dog.ceo', '/api/breeds/image/random');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      // The dog.ceo API returns a JSON object with a property
      // called 'message', which actually is the URL.
      imageUrl = json.decode(responseBody)['message'];
    } catch (exception) {
      print(exception);
    }
  }

  Future getDogInfo() async {
    // This is how http calls are done in flutter:
    HttpClient http = HttpClient();
    try {
      // Use darts Uri builder
      var uri = Uri.http('test-87a0f.firebaseapp.com', '/api/v1/doggos');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).toList();
      // var responseBodyJson = await response.transform(utf8.decoder).join();
      // dogName = json.decode(responseBodyJson).toString();
      dogInfo = responseBody;
    } catch (exception) {
      print(exception);
    }
  }
}
