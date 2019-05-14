import 'package:flutter/material.dart';
import 'package:newproject/resource/route/detail_screen.dart';

class StockWidget extends StatelessWidget {
  final Map code;
  bool isFavorite;
  StockWidget(this.code, {this.isFavorite = false});
  @override
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
                            builder: (context) => InforDetailsScreen(code,isFavorite: this.isFavorite),
                          ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${code["symbol"]}',
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 25,
                            )),
                        Text(
                          "${code["companyName"]}",
                          style: TextStyle(
                            fontFamily: 'Roboto',
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
                  Text(code['latestPrice'].toString(),
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 22,
                      )),
                  Row(
                    children: <Widget>[
                      code["changePercent"] > 0 ? Icon(
                        Icons.arrow_upward,
                        color: 
                            Colors.lightGreen,
                            
                      ) : Icon(Icons.arrow_downward, color: Colors.red[200]),
                      Text(code["change"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            color: code["change"] > 0
                                ? Colors.green
                                : Colors.red,
                            fontSize: 12,
                          )),
                    ],
                  ),
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
