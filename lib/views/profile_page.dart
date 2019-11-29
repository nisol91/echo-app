import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String lastname = '';
  String email = '';

  String points;
  bool loaded = false;

  @override
  initState() {
    super.initState();
    print(loaded);
    getUser();
  }

  void getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    email = user.email;
    name = user.displayName;

    new Future.delayed(new Duration(milliseconds: 1500), () {
      Firestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .getDocuments()
          .then((doc) {
        print('MAIL FETCH ${doc.documents[0]['email']}');
        print('NAME FETCH ${doc.documents[0]['fname']}');
        setState(() {
          name = doc.documents[0]['fname'];
          lastname = doc.documents[0]['surname'];

          email = doc.documents[0]['email'];
          points = doc.documents[0]['points'].toString();

          loaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Page'),
          actions: <Widget>[
            IconButton(
              iconSize: 35,
              icon: Icon(Icons.delete_forever),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            IconButton(
              iconSize: 35,
              icon: Icon(Icons.edit),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.height * 1,
            child: (loaded == true)
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'a',
                        child: Image.asset(
                          '',
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        name ?? name,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        lastname ?? lastname,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Colors.orangeAccent),
                      ),
                      Text(
                        email ?? email,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Colors.orangeAccent),
                      ),
                      Text(
                        points ?? points,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Colors.orangeAccent),
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()])));
  }
}
