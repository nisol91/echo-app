import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './views/profile_page.dart';
import 'package:flushbar/flushbar.dart';
import './views/corporate_list_view.dart';
import './views/corporate_list.dart';
import 'package:flutter/material.dart';
import './views/auth_screen.dart';
import './state/app_state.dart';
import 'app_state_container.dart';
import './viewmodels/crud_model_corporate.dart';
import 'locator.dart';
import 'package:provider/provider.dart';
import './views/add_corporate.dart';

void main() {
  setupLocator();
  runApp(new AppStateContainer(
    child: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  ThemeData get _themeData => new ThemeData(
        primaryColor: Colors.blueGrey[100],
        accentColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[300],
      );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => locator<CrudModel>()),
      ],
      child: MaterialApp(
        title: 'Echo App',
        theme: _themeData,
        routes: {
          '/': (BuildContext context) => new MyHomePage(title: 'Home Page'),
          '/auth': (BuildContext context) => new AuthScreen(),
          '/addCorporate': (BuildContext context) => new AddCorporate(),
        },
        // theme: ThemeData(brightness: Brightness.dark),
        // home: new MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String email = '';
  bool areYouAdmin = false;

  @override
  initState() {
    super.initState();
  }

  _logInPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AuthScreen();
        },
      ),
    );
  }

  _profilePage() async {
    final container = AppStateContainer.of(context);
    print(await container.ensureGoogleLoggedInOnStartUp());
    if (await container.ensureGoogleLoggedInOnStartUp() != null ||
        await container.ensureEmailLoggedInOnStartup() != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ProfilePage();
          },
        ),
      );
    } else {
      Flushbar(
        title: "Hey Ninja",
        message: "You need to login, to access this page",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.blueAccent[100],
      )..show(context);
    }
  }

  _corporatePage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return CorporateList();
        },
      ),
    );
  }

  _corporatePage_2() async {
    final container = AppStateContainer.of(context);
    print(await container.ensureGoogleLoggedInOnStartUp());
    if (await container.ensureGoogleLoggedInOnStartUp() != null ||
        await container.ensureEmailLoggedInOnStartup() != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return CorporateListView();
          },
        ),
      );
    } else {
      Flushbar(
        title: "Hey Ninja",
        message: "You need to login, to access this page",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.blueAccent[100],
      )..show(context);
    }
  }

  AppState appState;

  Widget get _pageToDisplay {
    if (appState.isLoading) {
      return _loadingView;
    } else {
      return _homeView;
    }
  }

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  // new
  Widget get _homeView {
    return Container(
        //
        );
  }

  @override
  Widget build(BuildContext context) {
    // This is the InheritedWidget in action.
    // You can reference the StatefulWidget that
    // wraps it like this, which allows you to access any
    // public method or property on it.
    var container = AppStateContainer.of(context);
    // For example, get grab its property called state!
    appState = container.state;
    // Everything this build method is called, which is when the state
    // changes, Flutter will 'get' the _pageToDisplay widget, which will
    // return the screen we want based on the appState.isLoading
    Widget body = _pageToDisplay;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        backgroundColor: Colors.blueGrey[400],
        // This is how you add new buttons to the top right of a material appBar.
        // You can add as many as you'd like.
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: _logInPage,
          ),
          IconButton(
            icon: Icon(Icons.library_add),
            onPressed: _corporatePage,
          ),
          (container.areYouAdmin == true)
              ? IconButton(
                  icon: Icon(Icons.library_add),
                  onPressed: _corporatePage_2,
                )
              : Container(),
          IconButton(
            icon: Icon(Icons.panorama_fish_eye),
            onPressed: _profilePage,
          ),
        ],
      ),
      body: body,
    );
  }
}
