import 'package:transparent_image/transparent_image.dart';

import '../app_state_container.dart';
import '../views/corporate_details_users.dart';
import 'package:flutter/material.dart';
import '../models/corporate_model.dart';
import '../views/corporate_details.dart';

class CorporateCard extends StatelessWidget {
  final Corporate corporateDetails;
  final Color featuredColor;

  CorporateCard({this.corporateDetails, this.featuredColor});

  @override
  Widget build(BuildContext context) {
    var tema = Theme.of(context);
    var container = AppStateContainer.of(context);
    return GestureDetector(
      onTap: () {
        if (container.areYouAdmin == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      CorporateDetails(corporate: corporateDetails)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      CorporateDetailsUsers(corporate: corporateDetails)));
        }
      },
      child: Padding(
        padding: EdgeInsets.all(3),
        child: Card(
          color: featuredColor,
          elevation: 5,
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Hero(
                //   tag: corporateDetails.id,
                //   child: Text('image url'),
                //   // child: Image.asset(
                //   //   'assets/${corporateDetails.img}.jpg',
                //   //   height: MediaQuery.of(context).size.height * 0.35,
                //   // ),
                // ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            Text(
                              corporateDetails.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  fontStyle: FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              '${corporateDetails.img}',
                              height: 70,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: LinearProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
