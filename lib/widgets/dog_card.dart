import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/dog_model.dart';
import '../views/dog_detail_page.dart';
import '../models/post.dart';

class DogCard extends StatefulWidget {
  final Dog dog;

  DogCard(this.dog);

  @override
  _DogCardState createState() => _DogCardState(dog);
}

class _DogCardState extends State<DogCard> {
  Dog dog;

  _DogCardState(this.dog);

  //con il metodo build unisco tutti i widget,
  // assemblandoli dentro a un container principale, che in questo caso è la dog card
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showDogDetailPage,
      child: Container(
        height: 115.0,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[dogImage, dogCard],
              )
              //in alternativa
              // Positioned(
              //   child: dogCard,
              // ),
              // Positioned(
              //   left: 20,
              //   top: 7.5,
              //   child: dogImage,
              // )
            ],
          ),
        ),
      ),
    );
  }

  showDogDetailPage() {
    print('tapped ${dog.name}');
    Navigator.of(context).push(
      MaterialPageRoute(
        // builder methods always take context!
        builder: (context) {
          return DogDetailPage(dog);
        },
      ),
    );
  }

  //metodi vari
  void initState() {
    super.initState();
    renderDogPic();
  }

  renderDogPic() async {
    await dog.getImageUrl();
    print(dog.imageUrl);
    if (mounted) {
      setState(() {
        renderUrl = dog.imageUrl;
      });
    }
  }

  // qui costruisco tutti i widget con il metodo get

  //dogCard
  Widget get dogCard {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
        ),
        width: MediaQuery.of(context).size.width * 0.7,
        height: 115.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.only(
              // top: 10,
              // bottom: 10,
              left: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(widget.dog.name),
                Text(widget.dog.description),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                    ),
                    Text(': ${widget.dog.rating} / 10'),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  //dogImage
  String renderUrl;

  //prima istanzio il dogAvatar e il placeholder,
  //poi ritorno il widget che gestisce entrambe

  Widget get dogImage {
    var dogAvatar = Hero(
        tag: dog,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(renderUrl ?? ''))),
        ));

    // Placeholder is a static container the same size as the dog image.
    var placeholder = Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
          ),
        ),
        alignment: Alignment.center,
        child: CircularProgressIndicator());

    // This is an animated widget built into flutter.
    return AnimatedCrossFade(
      // You pass it the starting widget and the ending widget.
      firstChild: placeholder,
      secondChild: dogAvatar,
      // Then, you pass it a ternary that should be based on your state
      //
      // If renderUrl is null tell the widget to use the placeholder,
      // otherwise use the dogAvatar.
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      // Finally, pass in the amount of time the fade should take.
      duration: Duration(milliseconds: 1000),
    );
  }
}
