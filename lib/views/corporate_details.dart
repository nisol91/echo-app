import 'package:flutter/material.dart';
import '../models/corporate_model.dart';
import '../services/crud_model_corporate.dart';
import 'package:provider/provider.dart';
import 'edit_corporate.dart';

class CorporateDetails extends StatelessWidget {
  final Corporate corporate;

  CorporateDetails({@required this.corporate});

  @override
  Widget build(BuildContext context) {
    final corporateProvider = Provider.of<CrudModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Corporate Details'),
        actions: <Widget>[
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              await corporateProvider.removeCorporate(corporate.id);
              Navigator.pop(context);
            },
          ),
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.edit),
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            corporate.name,
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic),
          ),
          Text(
            '${corporate.name} \$',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic,
                color: Colors.orangeAccent),
          )
        ],
      ),
    );
  }
}
