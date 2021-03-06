import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moviedate/secondscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Todoo')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> categoryData = [];


  @override
  void initState() {
    super.initState();
    getCategoryFromSharedPreference().then((List<String> data) {
      setState((){
        if (data != null) {
          categoryData = data.toList(
            growable: true
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: (){_neverSatisfied();}
          )
        ],
      ),
      body: new ListView(
        children: createListItems(categoryData),
      )
    );
  }

  void addCategory(String category) {
    if (category != null && category.isNotEmpty) {
      setState(() {
        categoryData.add(category);
      });
      saveCategoryToSharedPreference(categoryData);
    }
  }

  void onCateogrySelected(String category) {
    print("Selected Category $category");
    Navigator.of(context).push(new PageRouteBuilder(
      opaque: true,
      pageBuilder: (BuildContext context,_,__) {
        return new SecondScreenPage(category);
      },
      transitionsBuilder: (_,Animation<double> animation,__,Widget child) {
        return new SlideTransition(
          position : new Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero
            ).animate(animation),
          child: child
        );
      }
    ));

    // Navigator.push(context,new MaterialPageRoute(
    //   builder: (context) => new SecondScreenPage(category))
    //   );
  }

  TextEditingController mTextEditController = new TextEditingController();

  Future<Null> _neverSatisfied() async {
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
              addCategory(mTextEditController.text);
              mTextEditController.text = "";
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  List<Widget> createListItems(List<String> categoryData) {
    List<Widget> returnItems = new List<Widget>();
    for (int i =0; i < categoryData.length; i++) {
      returnItems.add(new ListTile(
        title: new Text(categoryData[i]),
        onTap: (){onCateogrySelected(categoryData[i]);},
      ));
    }
    return returnItems;
  }

  saveCategoryToSharedPreference(List<String> category) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList("data", category);
  }

  Future<List<String>> getCategoryFromSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList("data");
  }
}
