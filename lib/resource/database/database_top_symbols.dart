// To parse this JSON data, do
//
//     final dbTopSymbols = dbTopSymbolsFromJson(jsonString);

import 'dart:convert';

List<DbTopSymbols> dbTopSymbolsFromJson(String str) => new List<DbTopSymbols>.from(json.decode(str).map((x) => DbTopSymbols.fromMap(x)));

class DbTopSymbols {
  String symbol;
  String companyName;
  String primaryExchange;
  String sector;
  double open;
  double close;
  double high;
  double low;
  double latestPrice;
  double previousClose;
  double change;
  double changePercent;
  int marketCap;
  String latestSource;
  double peRatio;

  DbTopSymbols({
    this.symbol,
    this.companyName,
    this.primaryExchange,
    this.sector,
    this.open,
    this.close,
    this.high,
    this.low,
    this.latestPrice,
    this.previousClose,
    this.change,
    this.changePercent,
    this.marketCap,
    this.latestSource,
    this.peRatio,
  });

  factory DbTopSymbols.fromMap(Map<String, dynamic> json) => new DbTopSymbols(
    symbol: json["symbol"],
    companyName: json["companyName"],
    primaryExchange: json["primaryExchange"],
    sector: json["sector"],
    open: json["open"]==null?null:json["open"].toDouble(),
    close: json["close"]==null?null:json["close"].toDouble(),
    high: json["high"]==null?null:json["high"].toDouble(),
    low: json["low"]==null?null:json["low"].toDouble(),
    latestPrice: json["latestPrice"]==null?null:json["latestPrice"].toDouble(),
    previousClose: json["previousClose"]==null?null:json["previousClose"].toDouble(),
    change: json["change"]==null?null:json["change"].toDouble(),
    changePercent: json["changePercent"]==null?null:json["changePercent"].toDouble(),
    latestSource:json["latestSource"],
    marketCap: json["marketCap"],
    peRatio: json["peRatio"] == null ? null : json["peRatio"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "symbol": symbol,
    "companyName": companyName,
    "primaryExchange": primaryExchange,
    "sector": sector,
    "open": open,
    "close": close,
    "high": high,
    "low": low,
    "latestPrice": latestPrice,
    "previousClose": previousClose,
    "change": change,
    "changePercent": changePercent,
    "marketCap": marketCap,
    "latestSource":latestSource,
    "peRatio": peRatio == null ? null : peRatio,
  };
}


