
import 'package:flutter/material.dart';

import './database.dart';

void main() {
  runApp(MyApp());
  test();
}

void test() async {

  var topSymbols=await DbProvider.db.getTopSymbols();
  print("Get data completed");
  for(var f in topSymbols){
    print(f);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: (Text("Database Test"))),
    ));
  }
}
