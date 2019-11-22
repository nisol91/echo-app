import 'package:flutter/material.dart';

import 'dog_model.dart';

class DogDetailPage extends StatefulWidget {
  final Dog dog;

  DogDetailPage(this.dog);

  @override
  _DogDetailPageState createState() => _DogDetailPageState();
}

class _DogDetailPageState extends State<DogDetailPage> {
  final double dogAvatarSize = 150.0;
  double _sliderValue = 10.0;

  Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Slider(
                activeColor: Colors.blueGrey,
                min: 0,
                max: 10,
                value: _sliderValue,
                onChanged: (newRating) {
                  setState(() => _sliderValue = newRating);
                },
              ),
            ),
            Container(
              width: 50.0,
              alignment: Alignment.center,
              child: Text('${_sliderValue.toInt()}',
                  style: Theme.of(context).textTheme.display1),
            ),
          ],
        ),
        submitRatingButton
      ],
    );
  }

// Just like a route, this needs to be async, because it can return
// information when the user interacts.
  Future<Null> _ratingErrorDialog() async {
    // showDialog is a built-in Flutter method.
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error!'),
          content: Text("They're good dogs, Brant."),
          // This action uses the Navigator to dismiss the dialog.
          // This is where you could return information if you wanted to.
          actions: [
            FlatButton(
              child: Text('Try Again'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  updateRating() {
    if (_sliderValue < 6) {
      _ratingErrorDialog();
    } else {
      setState(() => widget.dog.rating = _sliderValue.toInt());
    }
  }

  Widget get submitRatingButton {
    return RaisedButton(
      onPressed: () => updateRating(),
      //oppure
      // onPressed: updateRating,
      child: Text('Submit'),
      color: Colors.blueGrey,
    );
  }

  Widget get dogImage {
    return Hero(
        tag: widget.dog,
        child: Container(
          height: dogAvatarSize,
          width: dogAvatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              const BoxShadow(
                  // just like CSS:
                  // it takes the same 4 properties
                  offset: const Offset(1.0, 2.0),
                  blurRadius: 2.0,
                  spreadRadius: -1.0,
                  color: const Color(0x33000000)),
              const BoxShadow(
                  offset: const Offset(2.0, 1.0),
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                  color: const Color(0x24000000)),
              const BoxShadow(
                  offset: const Offset(3.0, 1.0),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                  color: const Color(0x1F000000)),
            ],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget.dog.imageUrl),
            ),
          ),
        ));
  }

  Widget get rating {
    // Use a row to lay out widgets horizontally.
    return Row(
      // Center the widgets on the main-axis
      // which is the horizontal axis in a row.
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star,
          size: 40.0,
        ),
        Text(' ${widget.dog.rating} / 10',
            style: Theme.of(context).textTheme.display2),
      ],
    );
  }

  Widget get dogProfile {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: 550,
      decoration: BoxDecoration(
        // This would be a great opportunity to create a custom LinearGradient widget
        // that could be shared throughout the app but I'll leave that to you.
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.blueGrey[800],
            Colors.blueGrey[700],
            Colors.blueGrey[600],
            Colors.blueGrey[400],
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  dogImage,
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.dog.name,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Text(
                    widget.dog.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.dog.location),
                  ),
                  rating,
                  addYourRating,
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Meet ${widget.dog.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                dogProfile,
              ],
            )),
      ),
    );
  }
}
