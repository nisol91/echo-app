import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'state/app_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

//EFFETTIVA IMPLEMENTAZIONE DELLO STATO DELL APP (INHERITED WIDGET)
class AppStateContainer extends StatefulWidget {
  // Your apps state is managed by the container
  final AppState state;
  // This widget is simply the root of the tree,
  // so it has to have a child!
  final Widget child;

  AppStateContainer({
    @required this.child,
    this.state,
  });

  // This creates a method on the AppState that's just like 'of'
  // On MediaQueries, Theme, etc
  // This is the secret to accessing your AppState all over your app
  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => new _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  // Just padding the state through so we don't have to
  // manipulate it with widget.state.
  AppState state;

  // This is used to sign into Google, not Firebase.

  GoogleSignInAccount googleUser;
  // This class handles signing into Google.
  // It comes from the Firebase plugin.

  final googleSignIn = new GoogleSignIn();

  //for firebase user
  FirebaseUser firebaseUser;

  String email = '';
  bool areYouAdmin = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // You'll almost certainly want to do some logic
    // in InitState of your AppStateContainer. In this example, we'll eventually
    // write the methods to check the local state
    // for existing users and all that.
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState.loading();
      // fake some config loading
      print('INIT APP');
      initUser();
      getUser();
    }
  }

  //===========================================

  // Future<bool> signInWithEmail(String email, String password) async {
  //   try {
  //     AuthResult result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;
  //     if (user != null) {
  //       print(user);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  //===========================================

  Future<void> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      email = user.email;

      await Future.delayed(new Duration(milliseconds: 10), () {
        Firestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .getDocuments()
            .then((doc) {
          if (doc.documents[0]['role'] == 'admin') {
            print('ADMIN===========');
            if (!mounted) {
              return;
            }
            setState(() {
              areYouAdmin = true;
            });
          } else {
            print('false');
            setState(() {
              areYouAdmin = false;
            });
          }
        });
      });
    } else {
      print('false');
      setState(() {
        areYouAdmin = false;
      });
    }
  }

  //===========================================

  Future<bool> loginWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();

    DocumentSnapshot utente =
        await Firestore.instance.collection("users").document(user.uid).get();
    if (!utente.exists) {
      print('ancora non esisteva');
      Firestore.instance.collection("users").document(user.uid).setData({
        "points": 0,
        "fname": user.displayName,
        "surname": '',
        "role": 'user',
      });
    }

    Firestore.instance.collection("users").document(user.uid).updateData({
      "uid": user.uid,
      "email": user.email,
    });

    getUser();
    assert(user.uid == currentUser.uid);
    print('signInWithGoogle succeeded: $user');
    return true;
  }

  Future<Null> signOut() async {
    try {
      // Sign out with firebase
      await _auth.signOut();
      setState(() {
        firebaseUser = null;
      });
      // Sign out with google
      await googleSignIn.signOut();
      setState(() {
        googleUser = null;
      });

      getUser();

      print('logged out!!!');
    } catch (e) {
      print('error logging out from google');
    }
  }

  //===========================================
// If all goes well, when you launch the app
  // you'll see a loading spinner for 2 seconds
  // Then the HomeScreen main view will appear

  Future<Null> startCountdown() async {
    const timeOut = const Duration(seconds: 2);
    new Timer(timeOut, () {
      setState(() => state.isLoading = false);
    });
  }

  //===========================================

  Future<GoogleSignInAccount> ensureGoogleLoggedInOnStartUp() async {
    // That class has a currentUser if there's already a user signed in on
    // this device.
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      // but if not, Google should try to sign one in whos previously signed in
      // on this phone.
      user = await googleSignIn.signInSilently();
    }
    // NB: This could still possibly be null.
    googleUser = user;
    return user;
  }

  Future<FirebaseUser> ensureEmailLoggedInOnStartup() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    firebaseUser = user;
    print('FIREBASE USER ${firebaseUser}');
    return user;
  }

  //===========================================

  Future<Null> initUser() async {
    // First, check if a user exists.
    googleUser = await ensureGoogleLoggedInOnStartUp();
    firebaseUser = await ensureEmailLoggedInOnStartup();
    // If the user is null, we aren't loading anyhting
    // because there isn't anything to load.
    // This will force the homepage to navigate to the auth page.
    if (googleUser == null && firebaseUser == null) {
      setState(() {
        state.isLoading = false;
        print('NO USER LOGGED IN');
      });
    } else if (googleUser != null) {
      setState(() {
        state.isLoading = false;
        print('USER LOGGED IN -> ${googleUser.email}');
      });

      // Do some other stuff, handle later.
      startCountdown();
    } else if (firebaseUser != null) {
      setState(() {
        state.isLoading = false;
        print('USER LOGGED IN -> ${firebaseUser.email}');
      });

      // Do some other stuff, handle later.
      startCountdown();
    }
  }

  //===========================================

  // So the WidgetTree is actually
  // AppStateContainer --> InheritedStateContainer --> The rest of your app.
  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

// This is likely all your InheritedWidget will ever need.
class _InheritedStateContainer extends InheritedWidget {
  // The data is whatever this widget is passing down.
  final _AppStateContainerState data;

  // InheritedWidgets are always just wrappers.
  // So there has to be a child,
  // Although Flutter just knows to build the Widget thats passed to it
  // So you don't have have a build method or anything.
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a better way to do this, which you'll see later.
  // But basically, Flutter automatically calls this method when any data
  // in this widget is changed.
  // You can use this method to make sure that flutter actually should
  // repaint the tree, or do nothing.
  // It helps with performance.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
