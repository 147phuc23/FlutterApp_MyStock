import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newproject/flutter_candlesticks.dart';
import 'package:newproject/main.dart';
import 'package:newproject/resource/database/database.dart';

class InforDetailsScreen extends StatefulWidget {
  final code;
  bool isFavorite;
  List sampleData = [];
  InforDetailsScreen(this.code, {this.isFavorite = false});
  @override
  _InforDetailsScreenState createState() => _InforDetailsScreenState();
}

class _InforDetailsScreenState extends State<InforDetailsScreen> {
  String _graphMode = "1 month";

  Future<double> fetchData() async {
    switch (_graphMode) {
      case "1 month":
        widget.sampleData =
            await DbProvider.db.getChartInfo_1m(widget.code["symbol"]);
        break;
      case "1 day":
        widget.sampleData =
            await DbProvider.db.getChartInfo_1d(widget.code["symbol"]);
        break;
    }
    return widget.sampleData[0]["open"].toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          textTheme: isDarkTheme ? darkTheme.textTheme : lightTheme.textTheme,
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Icon(widget.isFavorite ? Icons.remove : Icons.add),
              onPressed: toggleFavorite,
            )
          ],
          title: Title(
            color: isDarkTheme ? Color(0xff190e18) : Color(0xffced9d2),
            child: Text(
              "Details",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
              ),
            ),
          ),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            createInfoTab(),
            createGraphContainer(),
          ],
        ));
  }

  Widget createInfoTab() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(" ${widget.code["companyName"]} ",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w200,
                )),
            Row(
              children: <Widget>[
                Text("${widget.code["symbol"]}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    )),
                Spacer(flex: 3),
                Text("${widget.code["primaryExchange"]}",
                    style: TextStyle(
                      fontSize: 21,
                    )),
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
            widget.code["latestSource"] == "Close"
                ? Row(
                    children: <Widget>[
                      Icon(
                        Icons.check_circle,
                        color: Colors.red,
                        size: 14,
                      ),
                      Text(
                        'Close Market',
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      )
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(100, 0, 179, 0),
                        size: 14,
                      ),
                      Text(
                        'Open Market',
                        style: TextStyle(
                            color: Color.fromARGB(100, 0, 179, 0),
                            fontSize: 14),
                      )
                    ],
                  ),
            Divider(color: Colors.greenAccent),
            Text(
              '${widget.code['latestPrice']} USD',
              style: TextStyle(
                  color: Color.fromARGB(100, 0, 179, 0), fontSize: 34),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Open: ${widget.code['open']}'),
                      Text('High: ${widget.code['high']}'),
                      Text('Low: ${widget.code['low']}'),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Column(
                    children: <Widget>[
                      Text('Close: ${widget.code['close']}'),
                      Text('Mkt Cap: ${widget.code['marketCap']}'),
                      Text('P/E ratio: ${widget.code['peRatio']}'),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            )
          ],
        ),
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.fromLTRB(13, 5, 5, 13),
      );
  Widget createGraphContainer() => Container(
        child: Container(
          padding: EdgeInsets.fromLTRB(13, 13, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Graph',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Spacer(),
                  DropdownButton(
                    hint: Text(_graphMode),
                    items: ["1 day", "1 month"].map((f) {
                      return DropdownMenuItem(
                        child: Text(f),
                        value: f,
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _graphMode = value;
                      });
                    },
                  ),
                ],
              ),
              Container(
                child: futureWidget(),
                height: 340,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      );

  Widget futureWidget() {
    return new FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return OHLCVGraph(
            data: widget.sampleData,
            enableGridLines: true,
            volumeProp: 0.2,
            lineWidth: 0.5,
            decreaseColor: Colors.redAccent,
            increaseColor: Colors.purple,
            labelPrefix: "",
          );
        } else if (snapshot.hasError) {
          return new Container(
            child: new Text("This data is not available",style: TextStyle(fontSize: 20),),
            alignment: Alignment.center,
          );
        } else
          return new CircularProgressIndicator();
      },
    );
  }

  void toggleFavorite() async {
    if (widget.isFavorite) {
      await DbProvider.db.deleteFromFavoriteList(widget.code['symbol']);
      setState(() {
        widget.isFavorite = false;
        print("click ${widget.isFavorite}");
      });
    } else {
      await DbProvider.db.addToFavoriteList(widget.code['symbol']);
      setState(() {
        widget.isFavorite = true;
        print("click ${widget.isFavorite}");
      });
    }
  }
}
