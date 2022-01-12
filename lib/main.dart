import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: Color(0xff87CEFA),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  var items = new List<Item>();

  HomePage(){
    items = [];

    // items.add(Item(title: "Item 1", done: false));
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));

  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var newTaskControler = TextEditingController();

  void adicionaItem(){

    if(newTaskControler.text.isEmpty) return;

    setState(() {
      widget.items.add(
        Item(
          title: newTaskControler.text,
          done: false,
        ),
      );
      newTaskControler.text = "";
      save();
    });
  }

  void remove(int index){
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var  prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if(data != null){
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode( widget.items ));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Text("joia"),
        title: TextFormField(
          controller: newTaskControler,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Color(0xffC71585),
            fontSize: 20,
          ),
          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(
              color: Colors.white
            )
          ),
        ),
        // actions: <Widget>[
        //   Icon(Icons.plus_one),
        // ],
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index){
          final item = widget.items[index];
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value){
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            key: Key(item.title),
            background: Container(
              color: Colors.red.withOpacity(0.2),
            ),
            onDismissed: (direction){
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton (
        onPressed: adicionaItem,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}