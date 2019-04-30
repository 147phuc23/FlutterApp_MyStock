import 'package:flutter/material.dart';
import 'main.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  bool darkThemeEnable = isDarkTheme;
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(220, 242, 242, 242),
        appBar: createMainAppBar('Setting'),
        body: ListView(children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.all(10),
            child: ListTile(
              trailing: Switch(
                value: true,
                onChanged: (bool x) {},
              ),
              title: Text('Notification'),
              enabled: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: ListTile(
              trailing: Switch(
                value: true,
                onChanged: (bool darkThemeEnable) {
                  
                },
              ),
              title: Text('Dark Theme'),
              enabled: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Account'),
              onTap: () {
                /*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountSettingScreen(),
                    ));*/
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('About us'),
              enabled: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Privacy'),
              enabled: true,
            ),
          ),
        ]));
  }
}
