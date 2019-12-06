import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../app_state_container.dart';
import 'registration_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() {
    return new AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final _formRecoverMailKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController forgetEmailInputController;

  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    forgetEmailInputController = new TextEditingController();

    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  _logInPageEmail() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return RegisterPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // new page needs scaffolding!
    var width = MediaQuery.of(context).size.width;
    // Get access to the AppState
    final container = AppStateContainer.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Log in Page'),
          backgroundColor: Colors.blueGrey,
        ),
        body: FutureBuilder<bool>(
            future: container.initUser(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                if (snapshot.data == false) {
                  return Container(
                    width: width,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SingleChildScrollView(
                            child: Form(
                                key: _loginFormKey,
                                child: Column(children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Email*',
                                        hintText: "john.doe@gmail.com"),
                                    controller: emailInputController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: emailValidator,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Password*',
                                        hintText: "********"),
                                    controller: pwdInputController,
                                    obscureText: true,
                                    validator: pwdValidator,
                                  ),
                                  RaisedButton(
                                    child: Text("Login"),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      if (_loginFormKey.currentState
                                          .validate()) {
                                        container
                                            .signInWithEmail(
                                                emailInputController.text,
                                                pwdInputController.text)
                                            .then((currentUser) => Firestore
                                                    .instance
                                                    .collection("users")
                                                    .document(
                                                        currentUser.user.uid)
                                                    .get()
                                                    .whenComplete(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());
                                                  AppStateContainer.of(context)
                                                      .getUser();

                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                          '/',
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);

                                                  Flushbar(
                                                    title: "Hey Ninjaaa",
                                                    message:
                                                        "Successfully Logged in!!! ${emailInputController.text}",
                                                    duration:
                                                        Duration(seconds: 3),
                                                    backgroundColor:
                                                        Colors.blueAccent[100],
                                                  )..show(context);
                                                }).catchError(
                                                        (err) => print(err)))
                                            .catchError((err) {
                                          print('ERROREEEEEE ${err}');
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          container.getUser();
                                          if (container.isMailVerified ==
                                              true) {
                                            Flushbar(
                                              title: "Hey Ninjaaa",
                                              message:
                                                  "wrong username or password",
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Colors.red[100],
                                            )..show(context);
                                            throw ('wrong username or password');
                                          } else {
                                            Flushbar(
                                              title: "Hey Ninjaaa",
                                              message:
                                                  "email not verified, check your inbox",
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Colors.red[100],
                                            )..show(context);
                                            throw ('email not verified');
                                          }
                                        });
                                      }
                                    },
                                  ),
                                  Text("Don't have an account yet?"),
                                  FlatButton(
                                    child: Text("Register here!"),
                                    onPressed: () {},
                                  )
                                ]))),
                        new RaisedButton(
                          onPressed: () async {
                            if (await FirebaseAuth.instance.currentUser() !=
                                null) {
                              Flushbar(
                                title: "Hey Ninja",
                                message: 'already logged in',
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.blueAccent[100],
                              )..show(context);
                            } else if (await FirebaseAuth.instance
                                    .currentUser() ==
                                null) {
                              container.loginWithGoogle().then((_) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false);

                                Flushbar(
                                  title: "Hey Ninja",
                                  message: 'logged in with google',
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.blueAccent[100],
                                )..show(context);
                              });
                            }
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.grey)),
                          child: new Container(
                            width: 250.0,
                            height: 50.0,
                            alignment: Alignment.center,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                          child: CircularProgressIndicator()),
                                      Center(
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image:
                                              'https://blog.hubspot.com/hubfs/image8-2.jpg',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                new Text(
                                  'Sign in With Google',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        new RaisedButton(
                          onPressed: () {
                            _logInPageEmail();
                          },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.grey)),
                          child: new Container(
                            width: 250.0,
                            height: 50.0,
                            alignment: Alignment.center,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Text(
                                  'Register with your own email',
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text("Forgot your password?"),
                        FlatButton(
                            child: Text("Reset here"),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Form(
                                      key: _formRecoverMailKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  labelText: 'Email*',
                                                  hintText:
                                                      "john.doe@gmail.com"),
                                              controller:
                                                  forgetEmailInputController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: emailValidator,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              child: Text("Submit"),
                                              onPressed: () {
                                                String usermail;
                                                Firestore.instance
                                                    .collection('users')
                                                    .where('email',
                                                        isEqualTo:
                                                            forgetEmailInputController
                                                                .text)
                                                    .getDocuments()
                                                    .then((doc) {
                                                  print(doc.documents[0]
                                                      ['email']);
                                                  usermail =
                                                      doc.documents[0]['email'];
                                                  print(
                                                      forgetEmailInputController
                                                          .text);
                                                  if (usermail.isNotEmpty &&
                                                      _formRecoverMailKey
                                                          .currentState
                                                          .validate()) {
                                                    _formRecoverMailKey
                                                        .currentState
                                                        .save();
                                                    FirebaseAuth.instance
                                                        .sendPasswordResetEmail(
                                                            email:
                                                                forgetEmailInputController
                                                                    .text);
                                                    forgetEmailInputController
                                                        .clear();

                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            new FocusNode());
                                                    Navigator.pop(context);
                                                    Flushbar(
                                                      title: "Hey Ninja",
                                                      message:
                                                          "Check your email adress",
                                                      duration:
                                                          Duration(seconds: 3),
                                                      backgroundColor: Colors
                                                          .blueAccent[100],
                                                    )..show(context);
                                                  } else {
                                                    print('EMAIL NON VALIDATA');
                                                  }
                                                }).catchError((err) => {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  new FocusNode()),
                                                          Flushbar(
                                                            title: "Hey Ninja",
                                                            message:
                                                                "Invalid user",
                                                            duration: Duration(
                                                                seconds: 3),
                                                            backgroundColor:
                                                                Colors.red[100],
                                                          )..show(context)
                                                        });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ],
                    ),
                  );
                } else {
                  return Container(
                      width: width,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new RaisedButton(
                              onPressed: () => {
                                print(container.firebaseUser),
                                print(container.googleUser),
                                container.signOut().whenComplete(() {
                                  Navigator.pop(context);
                                  Flushbar(
                                    title: "Hey Ninja",
                                    message: "Logged Out!!",
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.blueAccent[100],
                                  )..show(context);
                                }),
                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.grey)),
                              child: new Container(
                                width: 250.0,
                                height: 50.0,
                                alignment: Alignment.center,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Text(
                                      'Sign Out',
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]));
                }
              } else {
                return Container(
                    width: width,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                        ]));
                ;
              }
            }));
  }
}
