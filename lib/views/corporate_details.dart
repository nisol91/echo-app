import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../models/corporate_model.dart';
import '../services/crud_model_corporate.dart';
import 'package:provider/provider.dart';
import 'corporate_list_view.dart';
import 'edit_corporate.dart';

class CorporateDetails extends StatelessWidget {
  final Corporate corporate;

  CorporateDetails({@required this.corporate});

  @override
  Widget build(BuildContext context) {
    final corporateProvider = Provider.of<CrudModel>(context);
    var tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Corporate Details'),
        actions: <Widget>[
          IconButton(
              iconSize: 35,
              icon: Icon(Icons.delete_forever),
              color: tema.accentColor,
              onPressed: () {
                return showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                            new Text('You are going to delete this corporate'),
                        content: new Text(
                          'Are you sure my friend?',
                          style: new TextStyle(fontSize: 30.0),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                              onPressed: () {
                                print('no');
                                Navigator.pop(context);
                              },
                              child: new Text('no')),
                          new FlatButton(
                              onPressed: () {
                                print('yes');
                                {
                                  corporateProvider
                                      .removeCorporate(corporate.id);
                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                  Flushbar(
                                    title: "Hey Ninja",
                                    message: "Successfully deleted",
                                    duration: Duration(seconds: 3),
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                  )..show(context);
                                }
                              },
                              child: new Text('yes')),
                        ],
                      );
                    });
              }),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.edit),
            color: tema.accentColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ModifyCorporate(
                            corporate: corporate,
                          )));
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              '${corporate.img}',
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  corporate.name,
                  style: tema.textTheme.body2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Text(
              corporate.description,
              style: tema.textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }
}
