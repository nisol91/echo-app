import 'package:blank_flutter_app/views/corporate_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

import 'package:provider/provider.dart';
import '../models/corporate_model.dart';
import '../services/crud_model_corporate.dart';

class ModifyCorporate extends StatefulWidget {
  final Corporate corporate;

  ModifyCorporate({@required this.corporate});

  @override
  _ModifyCorporateState createState() => _ModifyCorporateState();
}

class _ModifyCorporateState extends State<ModifyCorporate> {
  final _formKey = GlobalKey<FormState>();

  String name;
  String description;
  String address;
  String logoUrl;
  String corporateType = 'Other';
  bool isFeatured = false;

  @override
  Widget build(BuildContext context) {
    final corporateProvider = Provider.of<CrudModel>(context);

    var tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Modify Corporate Details'),
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
                    initialValue: widget.corporate.name,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Corporate Title',
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
                    initialValue: widget.corporate.description,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Corporate Description',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Corporate Description';
                      }
                    },
                    onSaved: (value) => description = value),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    initialValue: widget.corporate.address,
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
                    initialValue: widget.corporate.img,
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
                splashColor: Colors.blueGrey,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    await corporateProvider.updateCorporate(
                        Corporate(
                          name: name,
                          description: description,
                          address: address,
                          img: logoUrl,
                          corporateType: corporateType,
                          featured: isFeatured,
                        ),
                        widget.corporate.id);
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                    Flushbar(
                      title: "Hey Ninja",
                      message: "Successfully edited Corporate ${name}",
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.blueAccent[100],
                    )..show(context);
                  }
                },
                child: Text('Modify Corporate',
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
