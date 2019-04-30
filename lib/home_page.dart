import 'package:flutter/material.dart';
import 'package:newproject/demodata.dart';
import 'package:newproject/settingscreen.dart';
import 'package:newproject/stockwidget.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePage({Key key}) : super(key: key);
  _MyHomePageState createState() => _MyHomePageState();
}

 
class _MyHomePageState extends State<MyHomePage> {
  @override
  //bool darkThemeEnable = false;
  //List<StockWidget> stocklist;
  Widget build(BuildContext context) {
    return Scaffold(            
      appBar: AppBar(        
        centerTitle: true,
        title: Title(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.android,
                color: Colors.blueAccent,
                size: 20,
              ),
              Text(
                "Main App",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
              Spacer(),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.menu),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SettingScreen()));
                    }, //Navigator(),
                  ),
                  FlatButton(child: Icon(Icons.search), onPressed: () {},)
                ],
              ),
            ],
          ),
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: data.map((f) {
            return StockWidget(f);
          }).toList(),
        ),
      ),
    );
  }
}
