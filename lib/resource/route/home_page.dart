import 'package:flutter/material.dart';
import 'package:newproject/demodata.dart';
import 'package:newproject/stockwidget.dart';
import 'package:newproject/main.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  MyHomeScreen({Key key}) : super(key: key);
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

 
class _MyHomeScreenState extends State<MyHomeScreen> {
  bool _isSearch = false;
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
                      Navigator.pushNamed(context, '/setting');
                    }, //Navigator(),
                  ),
                  FlatButton(child: Icon(Icons.search), onPressed: () {},)
                ],
              ),
            ],
          ),
          color: Colors.blue,
        ),
        backgroundColor: isDarkTheme? darkTheme.primaryColor: lightTheme.primaryColor,
      ),
      body: Container(
        child: buildListView(),
      ),
    );
  }

  ListView buildListView() {
    return ListView(
        scrollDirection: Axis.vertical,
        children: data.map((f) {
          return StockWidget(f);
        }).toList(),
      );
  }
}
