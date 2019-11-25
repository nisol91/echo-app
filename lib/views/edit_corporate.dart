import 'package:blank_flutter_app/views/corporate_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

import 'package:provider/provider.dart';
import '../models/corporate_model.dart';
import '../viewmodels/crud_model_corporate.dart';

class ModifyCorporate extends StatefulWidget {
  final Corporate corporate;

  ModifyCorporate({@required this.corporate});

  @override
  _ModifyCorporateState createState() => _ModifyCorporateState();
}

class _ModifyCorporateState extends State<ModifyCorporate> {
  final _formKey = GlobalKey<FormState>();

  String corporateType;

  String title;

  String price;

  @override
  Widget build(BuildContext context) {
    final corporateProvider = Provider.of<CrudModel>(context);
    corporateType = widget.corporate.img[0].toUpperCase() +
        widget.corporate.img.substring(1);
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
              TextFormField(
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
                  onSaved: (value) => title = value),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                  initialValue: widget.corporate.description,
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
                splashColor: Colors.blueGrey,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    await corporateProvider.updateCorporate(
                        Corporate(
                            name: title,
                            description: price,
                            img: corporateType.toLowerCase()),
                        widget.corporate.id);
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CorporateListView()));
                    Flushbar(
                      title: "Hey Ninja",
                      message: "Successfully edited Corporate ${title}",
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.blueAccent[100],
                    )..show(context);
                  }
                },
                child: Text('Modify Corporate',
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
