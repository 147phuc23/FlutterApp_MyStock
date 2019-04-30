import 'package:flutter/material.dart';
import 'package:newproject/demodata.dart';
import 'package:newproject/home_page.dart';
import 'stockwidget.dart';
import 'settingscreen.dart';
import 'resource/login_screen.dart';

void main() => runApp(MyApp());

bool isDarkTheme = false;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  // backgroundColor: Colors.white,
  // appBarTheme: AppBarTheme(
  //   color: Colors.lightBlue,
  // ),
  // textSelectionColor: Colors.orange,
  // inputDecorationTheme: InputDecorationTheme(
  //   border: OutlineInputBorder(
  //     borderSide: BorderSide(
  //       color: Colors.black38,
  //     ),
  //   ),
  //   errorStyle: TextStyle(
  //     color: Colors.red,
  //   ),
  // ),
  // primarySwatch: Colors.blueGrey,
  // primaryTextTheme: TextTheme(
  //   body1: TextStyle(
  //     color: Colors.black,
  //     textBaseline: TextBaseline.alphabetic,
  //   ),
  // ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  // backgroundColor: Colors.black,
  // appBarTheme: AppBarTheme(
  //   color: Colors.black26,
  // ),
  // textSelectionColor: Colors.orange,
  // inputDecorationTheme: InputDecorationTheme(
  //   border: OutlineInputBorder(
  //     borderSide: BorderSide(
  //       color: Colors.white,
  //     ),
  //   ),
  //   errorStyle: TextStyle(
  //     color: Colors.orange,
  //   ),
  // ),
  // primarySwatch: Colors.black,
  // primaryTextTheme: TextTheme(
  //   body1: TextStyle(
  //     color: Colors.white,
  //     textBaseline: TextBaseline.alphabetic,
  //   ),
  // ),
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
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/login' : (context) => LoginScreen(),
        '/home' : (context) => MyHomePage(),
        '/setting' : (context) => SettingScreen(),
      }
    );
  }
}

createMainAppBar(String x) => AppBar(
      textTheme: isDarkTheme ? darkTheme.textTheme : lightTheme.textTheme,
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
