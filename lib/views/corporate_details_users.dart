import 'package:flutter/material.dart';
import '../models/corporate_model.dart';
import '../services/crud_model_corporate.dart';
import 'package:provider/provider.dart';
import 'edit_corporate.dart';

class CorporateDetailsUsers extends StatelessWidget {
  final Corporate corporate;

  CorporateDetailsUsers({@required this.corporate});

  @override
  Widget build(BuildContext context) {
    final corporateProvider = Provider.of<CrudModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Corporate Details Users'),
        actions: <Widget>[],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: corporate.id,
            child: Image.network(
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
          ),
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
