import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/corporate_model.dart';
import '../services/crud_model_corporate.dart';
import 'corporate_list_view.dart';

class AddCorporate extends StatefulWidget {
  @override
  _AddCorporateState createState() => _AddCorporateState();
}

class _AddCorporateState extends State<AddCorporate> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String description;
  String address;
  String logoUrl;
  String corporateType = 'Other';
  bool isFeatured = false;

  @override
  Widget build(BuildContext context) {
    var corporateProvider = Provider.of<CrudModel>(context);
    var tema = Theme.of(context);

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
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
                    onSaved: (value) => name = value),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter The description';
                      }
                    },
                    onSaved: (value) => description = value),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Location',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter The location';
                      }
                    },
                    onSaved: (value) => address = value),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Logo Url',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter The logo url';
                      }
                    },
                    onSaved: (value) => logoUrl = value),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.height * 1,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: corporateType,
                    onChanged: (String newValue) {
                      setState(() {
                        corporateType = newValue;
                      });
                    },
                    items: <String>['Food', 'Transport', 'Tech', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text('Select corporate service'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.height * 1,
                  child: DropdownButton<bool>(
                    isExpanded: true,
                    value: isFeatured,
                    onChanged: (bool newValue) {
                      setState(() {
                        isFeatured = newValue;
                      });
                    },
                    items: <bool>[false, true]
                        .map<DropdownMenuItem<bool>>((bool value) {
                      return DropdownMenuItem<bool>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    hint: Text('Is featured?'),
                  ),
                ),
              ),
              RaisedButton(
                splashColor: tema.secondaryHeaderColor,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    await corporateProvider.addCorporate(Corporate(
                      name: name,
                      description: description,
                      address: address,
                      img: logoUrl,
                      corporateType: corporateType,
                      featured: isFeatured,
                      creationDate: Timestamp.now(),
                    ));
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Flushbar(
                      title: "Hey Ninja",
                      message: "Successfully added",
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.blueAccent[100],
                    )..show(context);
                  }
                },
                child: Text('add Corporate',
                    style: TextStyle(color: Colors.white)),
                color: tema.accentColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
