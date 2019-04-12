import 'package:flutter/material.dart';
import 'main.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(220,242, 242, 242),
        
        appBar: createMainAppBar('Setting'),
        body: ListView(children: <Widget>[
          Container(
            margin: EdgeInsets.all(14),
            color: Colors.white,
            child: ListTile(
              title: Text('Theme'),
              subtitle: Text('Black'),
              enabled: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(14),
            color: Colors.white,
            child: ListTile(
              trailing: Switch(value: true,onChanged: (bool x) {},),
              title: Text('Notification'),
              enabled: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(14),
            color: Colors.white,
            child: ListTile(
              title: Text('Account'),
              enabled: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(14),
            color: Colors.white,
            child: ListTile(
              title: Text('About us'),
              enabled: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(14),
            color: Colors.white,
            child: ListTile(
              title: Text('Privacy'),
              enabled: true,
            ),
          ),
        ]));
  }
}
