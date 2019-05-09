import 'package:flutter/material.dart';
import 'package:newproject/resource/route/detail_screen.dart';
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
