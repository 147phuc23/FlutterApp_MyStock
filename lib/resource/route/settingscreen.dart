import 'package:flutter/material.dart';
import 'package:newproject/main.dart';
import 'package:newproject/resource/route/account_screen.dart';
import 'package:newproject/resource/route/login_screen.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen(this.toggleTheme);
  final Function toggleTheme;
  @override
  _SettingScreenState createState() => _SettingScreenState(toggleTheme);
}

class _SettingScreenState extends State<SettingScreen> {
  final Function toggleTheme;
  _SettingScreenState(this.toggleTheme);  
  bool darkThemeEnable = isDarkTheme;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(        
        appBar: createAppBar('Setting'),
        body: ListView(children: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
              title: Text('Toggle Theme'),
              trailing: RaisedButton(                
                onPressed: toggleTheme,
                child: Text('Dark Theme'),                
              ),
            ),
          ),
          isLogedIn ? Container(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Account'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenAccount(),
                    ));
              },
            ),
          ): Container(
            margin: EdgeInsets.all(10),
            child: SizedBox(
                width: double.infinity,                
                child: FlatButton(
                  onPressed: () {        
                             
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Text(
                      'Log in',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
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

