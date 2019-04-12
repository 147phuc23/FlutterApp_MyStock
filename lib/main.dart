import 'package:flutter/material.dart';
import 'stockwidget.dart';
import 'settingscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage() ,
    );
  }
}
Theme mainTheme = Theme(data: ThemeData() , child: null);
List<StockCode> data = [
  StockCode('APPL', 'Apple Inc Company', 12),
  StockCode('AMZ', 'Amazon', 12.36),
  StockCode('GGL', 'Alphabet.Inc', 12),
  StockCode('APPL', 'Apple Inc Company', 12),
  StockCode('AMZ', 'Amazon', 12.36),
  StockCode('GGL', 'Alphabet.Inc', 12),
  StockCode('APPL', 'Apple Inc Company', 12),
  StockCode('AMZ', 'Amazon', 12.36),
  StockCode('GGL', 'Alphabet.Inc', 12),
  StockCode('APPL', 'Apple Inc Company', 12),
  StockCode('AMZ', 'Amazon', 12.36),
  StockCode('GGL', 'Alphabet.Inc', 12),
  StockCode('APPL', 'Apple Inc Company', 12),
  StockCode('AMZ', 'Amazon', 12.36),
  StockCode('GGL', 'Alphabet.Inc', 12),
];

class MyHomePage extends StatefulWidget {
  @override
  MyHomePage({Key key}) : super(key: key);
  _MyHomePageState createState() => _MyHomePageState();
}

AppBar createMainAppBar(String x) => AppBar(
      centerTitle: true,
      title: Title(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.android,
              size: 20,
            ),
            Text(
              "$x",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Spacer(),
          ],
        ),
        color: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
    );

class _MyHomePageState extends State<MyHomePage> {
  @override
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
              FlatButton(
                
                shape: CircleBorder(
                  side: BorderSide.none,
                ),
                child: Icon(Icons.menu),
                //color: Colors.transparent,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                }, //Navigator(),
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
