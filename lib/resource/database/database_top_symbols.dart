// To parse this JSON data, do
//
//     final dbTopSymbols = dbTopSymbolsFromJson(jsonString);

import 'dart:convert';

List<DbTopSymbols> dbTopSymbolsFromJson(String str) => new List<DbTopSymbols>.from(json.decode(str).map((x) => DbTopSymbols.fromJson(x)));

String dbTopSymbolsToJson(List<DbTopSymbols> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class DbTopSymbols {
  String symbol;
  double open;
  double close;
  double high;
  double low;
  double change;
  double changePercent;
  int marketCap;
  double peRatio;


  DbTopSymbols({
    this.symbol,
    this.open,
    this.close,
    this.high,
    this.low,
    this.change,
    this.changePercent,
    this.marketCap,
    this.peRatio,
  });

  factory DbTopSymbols.fromJson(Map<String, dynamic> json) => new DbTopSymbols(
    symbol: json["symbol"],
    open: json["open"].toDouble(),
    close: json["close"].toDouble(),
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    change: json["change"].toDouble(),
    changePercent: json["changePercent"].toDouble(),
    marketCap: json["marketCap"],
    peRatio: json["peRatio"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "open": open,
    "close": close,
    "high": high,
    "low": low,
    "change": change,
    "changePercent": changePercent,
    "marketCap": marketCap,
    "peRatio": peRatio,
  };
  Map<String, dynamic> toMap() => {
    "symbol": symbol,
    "open": open,
    "close": close,
    "high": high,
    "low": low,
    "change": change,
    "changePercent": changePercent,
    "marketCap": marketCap,
    "peRatio": peRatio,
  };
}


