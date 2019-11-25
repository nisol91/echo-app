import 'package:flutter/material.dart';
import '../models/corporate_model.dart';
import '../views/corporate_details.dart';

class CorporateCard extends StatelessWidget {
  final Corporate corporateDetails;

  CorporateCard({this.corporateDetails});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CorporateDetails(corporate: corporateDetails)));
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
                            fontStyle: FontStyle.italic),
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
