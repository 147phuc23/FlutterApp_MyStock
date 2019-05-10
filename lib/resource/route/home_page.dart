import 'package:flutter/material.dart';
import 'package:newproject/demodata.dart';
import 'package:newproject/resource/bloc/bloc.dart';
import 'package:newproject/resource/database/database.dart';
import 'package:newproject/search.dart';
import 'package:newproject/stockwidget.dart';
import 'package:newproject/main.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  MyHomeScreen({Key key}) : super(key: key);
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  bool _isSearching = false;

  TextEditingController _textController = new TextEditingController();
  @override
  //bool darkThemeEnable = false;
  //List<StockWidget> stocklist;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching
          ? AppBar(
              title: Title(
                  color: isDarkTheme
                      ? darkTheme.appBarTheme.color
                      : lightTheme.appBarTheme.color,
                  child: TextField(
                    controller: _textController,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.subhead,
                    onChanged: (value) => _handleFilter(value),
                    autofocus: true,
                    textCapitalization: TextCapitalization.none,
                    decoration: new InputDecoration.collapsed(
                        hintText: 'Search names and symbols...'),
                  )),
              backgroundColor: isDarkTheme
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            )
          : AppBar(
              leading: FlatButton(
                child: Icon(Icons.menu),
                onPressed: () {
                  Navigator.pushNamed(context, '/setting');
                }, //Navigator(),
              ),
              centerTitle: true,
              title: Title(
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Main App",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: CodeSearch(SearchBloc()));
                  },
                )
              ],
              backgroundColor: isDarkTheme
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
      body: Container(
        child: buildListView(),
      ),
    );
  }

  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  buildListView() {
    return RefreshIndicator(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: dataShow.map((f) {
          return StockWidget(f);
        }).toList(),
      ),
      onRefresh: () async {
        dataShow = await DbProvider.db.getTopSymbols();
        setState(() {});
      },
    );
  }

  _handleFilter(String value) {}
}
