import './views/corporate_list_view.dart';
import './views/corporate_list.dart';
import 'package:flutter/material.dart';
import './views/auth_screen.dart';
import './models/dog_model.dart';
import './views/new_dog_form.dart';
import './widgets/dog_list.dart';
import './state/app_state.dart';
import 'app_state_container.dart';
import './viewmodels/crud_model_corporate.dart';
import 'locator.dart';
import 'package:provider/provider.dart';

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
        title: 'Doggos Rating App',
        theme: _themeData,
        routes: {
          '/': (BuildContext context) =>
              new MyHomePage(title: 'Doggos Rating App'),
          '/auth': (BuildContext context) => new AuthScreen(),
        },
        // theme: ThemeData(brightness: Brightness.dark),
        // home: new MyHomePage(title: 'Doggos Rating App'),
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
  List<Dog> initialDoggos = []
    ..add(Dog('Ruby', 'Portland, OR, USA',
        'Ruby is a very good girl. Yes: Fetch, loungin\'. No: Dogs who get on furniture.'))
    ..add(Dog('Rex', 'Seattle, WA, USA', 'Best in Show 1999'))
    ..add(Dog('Rod Stewart', 'Prague, CZ',
        'Star good boy on international snooze team.'));
  // ..add(Dog('Herbert', 'Dallas, TX, USA', 'A Very Good Boy'))
  // ..add(Dog('Herbert', 'Dallas, TX, USA', 'A Very Good Boy'))
  // ..add(Dog('Herbert', 'Dallas, TX, USA', 'A Very Good Boy'))
  // ..add(Dog('Herbert', 'Dallas, TX, USA', 'A Very Good Boy'))
  // ..add(Dog('Buddy', 'North Pole, Earth', 'Self proclaimed human lover.'));

  _showNewDogForm() async {
    // Any time you're pushing a new route and expect that route
    // to return something back to you,
    // you need to use an async function.
    // In this case, the function will create a form page
    // which the user can fill out and submit.
    // On submission, the information in that form page
    // will be passed back to this function.

    // push a new route like you did in the last section
    Dog newDog = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddDogFormPage();
        },
      ),
    );
    // A null check, to make sure that the user didn't abandon the form.
    if (newDog != null) {
      // Add a newDog to our mock dog array.
      initialDoggos.add(newDog);
    }
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
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return CorporateListView();
        },
      ),
    );
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
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.blueGrey[900],
              Colors.blueGrey[500],
              Colors.blueGrey[400],
              Colors.blueGrey[200],
            ],
          )),
          child: Center(child: DogList(initialDoggos))),
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
            icon: Icon(Icons.add_circle_outline),
            onPressed: _showNewDogForm,
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: _logInPage,
          ),
          IconButton(
            icon: Icon(Icons.library_add),
            onPressed: _corporatePage,
          ),
          IconButton(
            icon: Icon(Icons.library_add),
            onPressed: _corporatePage_2,
          ),
        ],
      ),
      body: body,
    );
  }
}
