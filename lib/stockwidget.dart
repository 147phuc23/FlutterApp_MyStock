import 'package:flutter/material.dart';
import 'main.dart';

class StockCode {
  final String name, fullname, market;
  double price;
  StockCode(this.name, this.fullname, this.price, {this.market = 'NASDAQ'});
}

class StockWidget extends StatelessWidget {
  final StockCode code;
  @override
  StockWidget(this.code);
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InforDetailScreen(code),
                          ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(code.name,
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 20,
                            )),
                        Text(
                          code.fullname,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.black26,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(code.price.toString(),
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 22,
                      )),
                  Text(code.price.toString(),
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        color: Colors.red,
                        fontSize: 12,
                      )),
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}

class InforDetailScreen extends StatefulWidget {
  final StockCode code;
  InforDetailScreen(this.code);
  @override
  _InforDetailScreenState createState() => _InforDetailScreenState();
}

class _InforDetailScreenState extends State<InforDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createMainAppBar('Details'),
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
                child: Placeholder( ),
                width: MediaQuery.of(context).size.width,
                height: 240,
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
