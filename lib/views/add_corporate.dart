import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/corporate_model.dart';
import '../services/crud_model_corporate.dart';

class AddCorporate extends StatefulWidget {
  @override
  _AddCorporateState createState() => _AddCorporateState();
}

class _AddCorporateState extends State<AddCorporate> {
  final _formKey = GlobalKey<FormState>();
  String corporateType = 'Bag';
  String title;
  String price;

  @override
  Widget build(BuildContext context) {
    var corporateProvider = Provider.of<CrudModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Add Corporate'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Corporate Name',
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Corporate Title';
                    }
                  },
                  onSaved: (value) => title = value),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Price',
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter The price';
                    }
                  },
                  onSaved: (value) => price = value),
              DropdownButton<String>(
                value: corporateType,
                onChanged: (String newValue) {
                  setState(() {
                    corporateType = newValue;
                  });
                },
                items: <String>['Bag', 'Computer', 'Dress', 'Phone', 'Shoes']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              RaisedButton(
                splashColor: Colors.red,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    await corporateProvider.addCorporate(Corporate(
                        name: title,
                        creationDate: Timestamp.now(),
                        description: price,
                        img: corporateType.toLowerCase()));
                    Navigator.pop(context);
                  }
                },
                child: Text('add Corporate',
                    style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
