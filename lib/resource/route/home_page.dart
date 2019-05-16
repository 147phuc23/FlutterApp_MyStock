import 'package:flutter/material.dart';
import 'package:MyStock/demodata.dart';
import 'package:MyStock/resource/bloc/bloc.dart';
import 'package:MyStock/resource/database/database.dart';
import 'package:MyStock/search.dart';
import 'package:MyStock/stockwidget.dart';
import 'package:MyStock/main.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  MyHomeScreen({Key key}) : super(key: key);
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor:
            isDarkTheme ? darkTheme.primaryColor : lightTheme.primaryColor,
      ),
      body: Container(
        child: buildListView(),
      ),
    );
  }

  ThemeData createAppBarTheme(BuildContext context) {
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
        children: isLogedIn
            ? [
                [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text(
                      "FAVORITE",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ],
                favoriteData.map((f) {
                  return StockWidget(
                    f,
                    isFavorite: true,
                  );
                }).toList(),
                [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text(
                      "Top 10",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ],
                top10data.map((f) {
                  var data=favoriteData.firstWhere((item)=>item["symbol"]==f["symbol"],orElse: ()=>null);
                  if(data==null){
                    return StockWidget(f);
                  }else{
                    return StockWidget(f,isFavorite: true,);
                  }

                }).toList(),
/*                favoriteData.map((f) {
                  return Text(f['symbol']);
                }).toList(),*/
              ].expand((f) => f).toList()
            : [
                [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text(
                      "Top 10",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ],
                top10data.map((f) {
                  return StockWidget(f);
                }).toList(),
              ].expand((f) => f).toList(),
      ),
      onRefresh: () async {
        top10data = await DbProvider.db.getTopSymbols();
        List<String> favoriteSymbol = await DbProvider.db.getSymbolFromFavoriteList();
        favoriteData=[];
        if (favoriteSymbol != null) {
          var listRealInfo=await DbProvider.db.getListRealInfo(favoriteSymbol);
          for(var f in listRealInfo){
            favoriteData.add(f);
          }
        }
        else
          favoriteSymbol = [];
        setState(() {});
      },
    );
  }
}
