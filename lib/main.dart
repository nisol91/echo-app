import 'package:cloud_firestore/cloud_firestore.dart';
import './views/profile_page.dart';
import 'package:flushbar/flushbar.dart';
import './views/corporate_list_view.dart';
import './views/corporate_list.dart';
import 'package:flutter/material.dart';
import './views/auth_screen.dart';
import './state/app_state.dart';
import 'app_state_container.dart';
import './services/crud_model_corporate.dart';
import 'locator.dart';
import 'package:provider/provider.dart';
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
        primaryColor: Colors.lightGreen[500],
        accentColor: Colors.lightGreen[900],
        scaffoldBackgroundColor: Colors.white,
        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
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

  Widget get _homeView {
    final corporateProvider = Provider.of<CrudModel>(context);

    return StreamBuilder(
        stream: corporateProvider.fetchCorporatesAsStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            print('fatto');

            corporates = snapshot.data.documents
                .map((doc) => Corporate.fromMap(doc.data, doc.documentID))
                .toList();
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: corporates.length,
                          itemBuilder: (buildContext, index) => CorporateCard(
                              corporateDetails: corporates[index]),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: corporates.length,
                          itemBuilder: (buildContext, index) => CorporateCard(
                              corporateDetails: corporates[index]),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          } else {
            print('loading');

            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tema = Theme.of(context);

    var container = AppStateContainer.of(context);

    appState = container.state;

    return (!appState.isLoading)
        ? new Scaffold(
            appBar: new AppBar(
              title: new Text(widget.title),
              backgroundColor: tema.primaryColor,
              bottom: new TabBar(controller: controller, tabs: <Tab>[
                new Tab(
                    icon: new Icon(
                  Icons.arrow_forward,
                  color: tema.accentColor,
                )),
                new Tab(
                    icon: new Icon(Icons.arrow_downward,
                        color: tema.accentColor)),
                new Tab(
                    icon: new Icon(Icons.arrow_back, color: tema.accentColor))
              ]),
              // This is how you add new buttons to the top right of a material appBar.
              // You can add as many as you'd like.
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: _logInPage,
                  color: tema.accentColor,
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: _corporatePage,
                  color: tema.accentColor,
                ),
                (container.areYouAdmin == true)
                    ? IconButton(
                        icon: Icon(Icons.library_add),
                        onPressed: _corporatePage_2,
                        color: tema.accentColor,
                      )
                    : Container(),
                IconButton(
                  icon: Icon(Icons.panorama_fish_eye),
                  onPressed: _profilePage,
                  color: tema.accentColor,
                ),
              ],
            ),
            body: Container(
              height: MediaQuery.of(context).size.height * 1,
              child: TabBarView(
                controller: controller,
                children: [
                  _homeView,
                  Text(
                      'tab con lista di tutte le aziende e filtro per ricerca'),
                  Text('tab cosa ci metto?una mappa? una lista di citta?'),
                  // new CorporateList(),
                  // new AuthScreen(),
                ],
              ),
            ))
        : _loadingView;
  }
}
