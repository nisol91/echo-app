import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'models/corporate_model.dart';
import 'widgets/corporate_card.dart';

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
          '/': (BuildContext context) => new MyHomePage(title: 'Echo'),
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String email = '';
  bool areYouAdmin = false;
  List<Corporate> corporates;
  TabController controller;

  @override
  initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
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

  Widget get _loadingView {
    return new Scaffold(
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('ECHO'),
            new CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  // new
  Widget get _homeView {
    final corporateProvider = Provider.of<CrudModel>(context);

    return Container(
      width: MediaQuery.of(context).size.width * 1,
      padding: EdgeInsets.all(10),
      child: StreamBuilder(
          stream: corporateProvider.fetchCorporatesAsStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              print('fatto');

              corporates = snapshot.data.documents
                  .map((doc) => Corporate.fromMap(doc.data, doc.documentID))
                  .toList();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: corporates.length,
                itemBuilder: (buildContext, index) =>
                    CorporateCard(corporateDetails: corporates[index]),
              );
            } else {
              print('loading');

              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[CircularProgressIndicator()],
                ),
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
    return (!appState.isLoading)
        ? new Scaffold(
            appBar: new AppBar(
              title: new Text(widget.title),
              backgroundColor: Colors.blueGrey[400],
              bottom: new TabBar(controller: controller, tabs: <Tab>[
                new Tab(icon: new Icon(Icons.arrow_forward)),
                new Tab(icon: new Icon(Icons.arrow_downward)),
                new Tab(icon: new Icon(Icons.arrow_back))
              ]),
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
            body: TabBarView(
              controller: controller,
              children: [
                _homeView,
                new CorporateList(),
                new AuthScreen(),
              ],
            ),
          )
        : _loadingView;
  }
}
