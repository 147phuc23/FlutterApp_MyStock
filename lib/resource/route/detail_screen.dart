import 'package:flutter/material.dart';
import 'package:newproject/flutter_candlesticks.dart';
import 'package:newproject/main.dart';
import 'package:newproject/stockwidget.dart';


class InforDetailScreen extends StatefulWidget {
  final StockCode code;
  InforDetailScreen(this.code);
  @override
  _InforDetailScreenState createState() => _InforDetailScreenState();
}

class _InforDetailScreenState extends State<InforDetailScreen> {

  List sampleData = [
    {"open":50.0, "high":100.0, "low":40.0, "close":80, "volumeto":5000.0},
    {"open":80.0, "high":90.0, "low":55.0, "close":65, "volumeto":4000.0},
    {"open":65.0, "high":120.0, "low":60.0, "close":90, "volumeto":7000.0},
    {"open":90.0, "high":95.0, "low":85.0, "close":80, "volumeto":2000.0},
    {"open":80.0, "high":85.0, "low":40.0, "close":50, "volumeto":3000.0},
    {"open":50.0, "high":100.0, "low":40.0, "close":80, "volumeto":5000.0},
    {"open":80.0, "high":90.0, "low":55.0, "close":65, "volumeto":4000.0},
    {"open":65.0, "high":120.0, "low":60.0, "close":90, "volumeto":7000.0},
    {"open":90.0, "high":95.0, "low":85.0, "close":80, "volumeto":2000.0},
    {"open":80.0, "high":85.0, "low":40.0, "close":50, "volumeto":3000.0},
    {"open":50.0, "high":100.0, "low":40.0, "close":80, "volumeto":5000.0},
    {"open":80.0, "high":90.0, "low":55.0, "close":65, "volumeto":4000.0},
    {"open":65.0, "high":120.0, "low":60.0, "close":90, "volumeto":7000.0},
    {"open":90.0, "high":95.0, "low":85.0, "close":80, "volumeto":2000.0},
    {"open":80.0, "high":85.0, "low":40.0, "close":50, "volumeto":3000.0},
    {"open":50.0, "high":100.0, "low":40.0, "close":80, "volumeto":5000.0},
    {"open":80.0, "high":90.0, "low":55.0, "close":65, "volumeto":4000.0},
    {"open":65.0, "high":120.0, "low":60.0, "close":90, "volumeto":7000.0},
    {"open":90.0, "high":95.0, "low":85.0, "close":80, "volumeto":2000.0},
    {"open":80.0, "high":85.0, "low":40.0, "close":50, "volumeto":3000.0},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createAppBar('Details'),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            createInfoTab(),
            createGraphContainer(),
            createRawDataContainer(),
          ],
        ));
  }

  Widget createInfoTab() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${widget.code.fullname}',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w200,
                )),
            Row(
              children: <Widget>[
                Text('${widget.code.name}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    )),
                Spacer(flex: 3),
                Text('${widget.code.market}',
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.black54,
                    )),
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  color: Color.fromARGB(100, 0, 179, 0),
                  size: 14,
                ),
                Text(
                  'Open Market',
                  style: TextStyle(
                      color: Color.fromARGB(100, 0, 179, 0), fontSize: 14),
                )
              ],
            ),
            Divider(color: Colors.greenAccent),
            Text(
              '${widget.code.price} USD',
              style: TextStyle(
                  color: Color.fromARGB(100, 0, 179, 0), fontSize: 34),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Open'),
                      Text('High'),
                      Text('Low'),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Column(
                    children: <Widget>[
                      Text('Mkt Cap'),
                      Text('P/E ratio'),
                      Text('Div Yeild'),
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
              Text(
                'Graph',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Container(
                child: OHLCVGraph(
                  data: sampleData,
                  enableGridLines: true,
                  volumeProp: 0.5,
                  lineWidth: 0.6,
                  decreaseColor: Colors.orangeAccent,
                  increaseColor: Colors.purple,
                  labelPrefix: "",
                ),
                height: 340,
                width: MediaQuery.of(context).size.width,
                
              ),
            ],
          ),
        ),
      );
  Widget createRawDataContainer() => Container(
        child: Container(
          padding: EdgeInsets.fromLTRB(13, 13, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Raw Data',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ),
      );
}
