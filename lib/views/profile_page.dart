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
  String profilePic = '';

  String points;
  bool loaded = false;

  @override
  initState() {
    super.initState();
    getUser();
  }

  Future<bool> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      email = user.email;
      name = user.displayName;
      profilePic = user.photoUrl;

      new Future.delayed(new Duration(milliseconds: 100), () {
        Firestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .getDocuments()
            .then((doc) {
          print('MAIL FETCH ${doc.documents[0]['email']}');
          print('NAME FETCH ${doc.documents[0]['fname']}');

          if (!mounted) {
            return;
          }
          setState(() {
            name = doc.documents[0]['fname'];
            lastname = doc.documents[0]['surname'];

            email = doc.documents[0]['email'];
            points = doc.documents[0]['points'].toString();

            loaded = true;
          });
        });
      });

      return true;
    } else {
      return false;
    }
  }

//so che non è asincrona e quindi sarebbe poco ortodosso perchè non aspetta
//che finisca la chiamata asincrona qui sopra all user
//, pero tanto è solo per una sicurezza della pagina utente se per caso qualcuno
// riuscisse a navigarci direttamente, comunque non la vede se non è loggato con una mail
  Widget get _pageToDisplay {
    if (loaded == false) {
      print('loading');

      return _loading;
    } else {
      if (email != '') {
        print('dentro a profile view');
        print(email);
        return _profileView;
      } else {
        print('dentro a no access');

        return _noAccess;
      }
    }
  }

  Widget get _loading {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[CircularProgressIndicator()],
      ),
    );
  }

  Widget get _noAccess {
    return new Text(
      'you need to login',
      style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 10,
          fontStyle: FontStyle.italic),
    );
  }

  Widget get _profileView {
    return Container(
        width: MediaQuery.of(context).size.height * 1,
        child: (loaded == true)
            ? Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    '${profilePic ?? profilePic}',
                    height: 70,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: LinearProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                  Text(
                    name ?? name,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontStyle: FontStyle.normal),
                  ),
                  Text(
                    lastname ?? lastname,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey[500]),
                  ),
                  Text(
                    email ?? email,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey[500]),
                  ),
                  Text(
                    points ?? points,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey[500]),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[CircularProgressIndicator()]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Page'),
          actions: <Widget>[],
        ),
        body: _pageToDisplay);
  }
}
