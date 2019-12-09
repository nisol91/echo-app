import 'package:flutter/material.dart';
import '../models/company_model.dart';
import '../services/crud_model_company.dart';
import 'package:provider/provider.dart';
import 'edit_company.dart';

class CompanyDetailsUsers extends StatelessWidget {
  final Company company;

  CompanyDetailsUsers({@required this.company});

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CrudModelCompany>(context);
    var tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Company Details Users'),
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
              '${company.img}',
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
              company.name,
              style: tema.textTheme.body2,
            ),
            Text(
              company.description,
              style: tema.textTheme.body1,
            ),
          ],
        ),
      ),
    );
  }
}
