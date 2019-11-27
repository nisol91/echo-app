import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app_state_container.dart';
import 'registration_page.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() {
    return new AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
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
        body: Container(
          width: width,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                onPressed: () => container.loginWithGoogle(),
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
                        child: new Image.network(
                          'https://blog.hubspot.com/hubfs/image8-2.jpg',
                          width: 60.0,
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
              new RaisedButton(
                onPressed: () => container.signOut(),
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
              ),
              Text("Forgot your password?"),
              FlatButton(
                child: Text("Reset here"),
                onPressed: () {
                  // FirebaseAuth.instance.sendPasswordResetEmail(userEmail)
                  //   .addOnCompleteListener(new OnCompleteListener<Void>() {
                  //       @Override
                  //       public void onComplete(@NonNull Task<Void> task) {
                  //           if (task.isSuccessful()) {
                  //               Toast.makeText(ResetActivity.this, "We have sent you instructions to reset your password!", Toast.LENGTH_SHORT).show();
                  //           } else {
                  //               Toast.makeText(ResetActivity.this, "Failed to send reset email!", Toast.LENGTH_SHORT).show();
                  //           }

                  //           progressBar.setVisibility(View.GONE);
                  //       }
                  //   });
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ));
  }
}
