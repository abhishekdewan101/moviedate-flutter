import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new SecondScreenWidget());

class SecondScreenWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Secon Screen Title',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new SecondScreenPage("")
    );
  }
}

class SecondScreenPage extends StatefulWidget {

  final String title;


  SecondScreenPage(this.title);// ignore: missing_function_body

  @override
  SecondScreenState createState() => new SecondScreenState();

}

class SecondScreenState extends State<SecondScreenPage> {

  List<String> categoryListData = [];

  @override
  void initState() {
    super.initState();
    getCategoryFromSharedPreference().then((List<String>data) {
      setState(() {
        if (data != null) {
          categoryListData = data.toList(
            growable: true
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.add), onPressed: () {
              addTodoForCategory();
            })
          ],
        ),
        body: new ListView(
          children: createListItems(categoryListData),
        )
    );
  }

  List<Widget> createListItems(List<String> categoryData) {
    List<Widget> returnItems = new List<Widget>();
    for (int i =0; i < categoryData.length; i++) {
      returnItems.add(new ListTile(
        title: new Text(categoryData[i]),
        onTap: (){},
      ));
    }
    return returnItems;
  }

  TextEditingController mTextEditController = new TextEditingController();

  Future<Null> addTodoForCategory() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      child: new AlertDialog(
        title: new Text('Rewind and remember'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('What would like to add?'),
              new TextField(controller: mTextEditController,
                  decoration: new InputDecoration(
                      hintText: "Add a new todo here"
                  )
              )
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Add'),
            onPressed: () {
              addTodoToCategory(mTextEditController.text);
              mTextEditController.text = "";
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void addTodoToCategory(String todo) {
    if (todo != null && todo.isNotEmpty) {
      setState(() {
        categoryListData.add(todo);
      });
      saveCategoryToSharedPreference(categoryListData);
    }
  }

  saveCategoryToSharedPreference(List<String> category) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList(widget.title, category);
  }

  Future<List<String>> getCategoryFromSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(widget.title);
  }

}