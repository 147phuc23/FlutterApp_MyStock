// To parse this JSON data, do
//
//     final dbTopSymbols = dbTopSymbolsFromJson(jsonString);

import 'dart:convert';
import './database_interface_data_tranform.dart';

List<DbTopSymbols> dbTopSymbolsFromJson(String str) => new List<DbTopSymbols>.from(json.decode(str).map((x) => DbTopSymbols.fromMap(x)));

class DbTopSymbols implements DataTranform{
  String symbol;
  String companyName;
  double open;
  double close;
  double high;
  double low;
  double change;
  double changePercent;
  int marketCap;
  double peRatio;
  double latestPrice;

  DbTopSymbols({
    this.symbol,
    this.companyName,
    this.open,
    this.close,
    this.high,
    this.low,
    this.change,
    this.changePercent,
    this.marketCap,
    this.peRatio,
    this.latestPrice
  });

  factory DbTopSymbols.fromMap(Map<String, dynamic> json) => new DbTopSymbols(
    symbol: json["symbol"],
    companyName:json["companyName"],
    open: json["open"].toDouble(),
    close: json["close"].toDouble(),
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    change: json["change"].toDouble(),
    changePercent: json["changePercent"].toDouble(),
    marketCap: json["marketCap"],
    peRatio: json["peRatio"].toDouble(),
    latestPrice: json["latestPrice"].toDouble()
  );

  Map<String, dynamic> toMap() => {
    "symbol": symbol,
    "companyName":companyName,
    "open": open,
    "close": close,
    "high": high,
    "low": low,
    "change": change,
    "changePercent": changePercent,
    "marketCap": marketCap,
    "peRatio": peRatio,
    "latestPrice":latestPrice
  };
}


