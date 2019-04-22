// To parse this JSON data, do
//
//     final dbStockExchange = dbStockExchangeFromJson(jsonString);

import 'dart:convert';

List<DbStockExchange> dbStockExchangeFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<DbStockExchange>.from(
      jsonData.map((x) => DbStockExchange.fromJson(x)));
}

String dbStockExchangeToJson(List<DbStockExchange> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class DbStockExchange {
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

  factory DbStockExchange.fromJson(Map<String, dynamic> json) =>
      new DbStockExchange(
        mic: json["mic"],
        tapeId: json["tapeId"],
        venueName: json["venueName"],
        volume: json["volume"],
        tapeA: json["tapeA"],
        tapeB: json["tapeB"],
        tapeC: json["tapeC"],
        marketPercent: json["marketPercent"].toDouble(),
        lastUpdated: json["lastUpdated"],
      );

  Map<String, dynamic> toJson() => {
        "mic": mic,
        "tapeId": tapeId,
        "venueName": venueName,
        "volume": volume,
        "tapeA": tapeA,
        "tapeB": tapeB,
        "tapeC": tapeC,
        "marketPercent": marketPercent,
        "lastUpdated": lastUpdated,
      };
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
