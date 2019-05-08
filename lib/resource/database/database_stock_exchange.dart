// To parse this JSON data, do
//
//     final dbStockExchange = dbStockExchangeFromJson(jsonString);

import 'dart:convert';
import './database_interface_data_tranform.dart';

List<DbStockExchange> dbStockExchangeFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<DbStockExchange>.from(
      jsonData.map((x) => DbStockExchange.fromMap(x)));
}

class DbStockExchange implements DataTranform{
  String mic;
  String tapeId;
  String venueName;
  int volume;
  int tapeA;
  int tapeB;
  int tapeC;
  double marketPercent;
  dynamic lastUpdated;

  DbStockExchange({
    this.mic,
    this.tapeId,
    this.venueName,
    this.volume,
    this.tapeA,
    this.tapeB,
    this.tapeC,
    this.marketPercent,
    this.lastUpdated,
  });


  Map<String, dynamic> toMap() {
    return {
      "mic": mic,
      "tapeId": tapeId,
      "venueName": venueName,
      "volume": volume,
      "tapeA": tapeA,
      "tapeB": tapeB,
      "tapeC": tapeC,
      "marketPercent": marketPercent,
      "lastUpdated": lastUpdated
    };
  }

  factory DbStockExchange.fromMap(Map<String, dynamic> data) =>
      new DbStockExchange(
          mic: data['mic'],
          tapeId: data['tapeId'],
          venueName: data['venueName'],
          volume: data['volume'],
          tapeA: data['tapeA'],
          tapeB: data['tapeB'],
          tapeC: data['tapeC'],
          marketPercent: data['marketPercent'],
          lastUpdated: data['lastUpdated']);
}
