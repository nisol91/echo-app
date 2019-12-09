import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../services/crud_model_service.dart';
import 'package:provider/provider.dart';
// import 'edit_service.dart';

class ServiceDetailsUsers extends StatelessWidget {
  final Service service;

  ServiceDetailsUsers({@required this.service});

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<CrudModelService>(context);
    var tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details Users'),
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
              '${service.img}',
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
              service.name,
              style: tema.textTheme.body2,
            ),
            Text(
              service.description,
              style: tema.textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }
}
