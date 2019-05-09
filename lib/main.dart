import 'package:flutter/material.dart';
import 'package:newproject/demodata.dart';
import 'package:newproject/resource/database/database.dart';
import 'package:newproject/resource/route/home_page.dart';
import 'package:newproject/resource/route/login_screen.dart';
import 'package:newproject/resource/route/settingscreen.dart';

String username = "abcxyzt";
String password = "123456";
bool isLogedIn = false;

void main() async {
  dataShow = await DbProvider.db.getTopSymbols();
  runApp(MyApp());
}

bool isDarkTheme = false;
final ThemeData lightTheme = new ThemeData(
  primarySwatch: Colors.purple,
  brightness: Brightness.light,
  accentColor: Colors.purpleAccent[100],
  primaryColor: Colors.white,
  primaryColorLight: Colors.purple[700],
  textSelectionHandleColor: Colors.purple[700],
  dividerColor: Colors.grey[200],
  bottomAppBarColor: Colors.grey[200],
  buttonColor: Colors.purple[700],
  iconTheme: new IconThemeData(color: Colors.white),
  primaryIconTheme: new IconThemeData(color: Colors.black),
  accentIconTheme: new IconThemeData(color: Colors.purple[700]),
  disabledColor: Colors.grey[500],
);

final ThemeData darkTheme = new ThemeData(
  primarySwatch: Colors.purple,
  brightness: Brightness.dark,
  accentColor: Colors.deepPurpleAccent[100],
  primaryColor: Color.fromRGBO(50, 50, 57, 1.0),
  primaryColorLight: Colors.deepPurpleAccent[100],
  textSelectionHandleColor: Colors.deepPurpleAccent[100],
  buttonColor: Colors.deepPurpleAccent[100],
  iconTheme: new IconThemeData(color: Colors.white),
  accentIconTheme: new IconThemeData(color: Colors.deepPurpleAccent[100]),
  cardColor: Color.fromRGBO(55, 55, 55, 1.0),
  dividerColor: Color.fromRGBO(60, 60, 60, 1.0),
  bottomAppBarColor: Colors.black26,
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  bool isDarkThemeEnabled = isDarkTheme;
  void toggleTheme() {
    isDarkThemeEnabled = isDarkTheme = !isDarkThemeEnabled;
    setState(() {});
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: isDarkTheme ? darkTheme : lightTheme,
        home: LoginScreen(),
        routes: <String, WidgetBuilder>{
          '/login': (context) => LoginScreen(),
          '/home': (context) => MyHomeScreen(),
          '/setting': (context) => SettingScreen(toggleTheme),
        });
  }
}

createAppBar(String x) => AppBar(
      textTheme: isDarkTheme ? darkTheme.textTheme : lightTheme.textTheme,
      centerTitle: true,
      title: Title(
        color: isDarkTheme ? Color(0xff190e18) : Color(0xffced9d2),
        child: Text(
          "$x",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
          ),
        ),
      ),
    );
