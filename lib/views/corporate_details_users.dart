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
    final corporateProvider = Provider.of<CrudModelCorporate>(context);
    var tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Corporate Details Users'),
        actions: <Widget>[],
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
            Text(
              corporate.name,
              style: tema.textTheme.body2,
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
