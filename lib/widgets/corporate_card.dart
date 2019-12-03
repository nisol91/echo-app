import '../app_state_container.dart';
import '../views/corporate_details_users.dart';
import 'package:flutter/material.dart';
import '../models/corporate_model.dart';
import '../views/corporate_details.dart';

class CorporateCard extends StatelessWidget {
  final Corporate corporateDetails;

  CorporateCard({this.corporateDetails});

  @override
  Widget build(BuildContext context) {
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
          elevation: 5,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: <Widget>[
                Hero(
                  tag: corporateDetails.id,
                  child: Text('image url'),
                  // child: Image.asset(
                  //   'assets/${corporateDetails.img}.jpg',
                  //   height: MediaQuery.of(context).size.height * 0.35,
                  // ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        corporateDetails.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                      ),
                      Text(
                        '${corporateDetails.name} \$',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Colors.orangeAccent),
                      ),
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
