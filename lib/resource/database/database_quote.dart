// To parse this JSON data, do
//
//     final dbQuote = dbQuoteFromJson(jsonString);

import 'dart:convert';
import './database_interface_data_tranform.dart';

DbQuote dbQuoteFromJson(String str) => DbQuote.fromMap(json.decode(str));

class DbQuote implements DataTranform{
  String symbol;
  String companyName;
  String primaryExchange;
  String sector;
  String calculationPrice;
  double open;
  int openTime;
  double close;
  int closeTime;
  double high;
  double low;
  double latestPrice;
  String latestSource;
  String latestTime;
  int latestUpdate;
  int latestVolume;
  double previousClose;
  double change;
  double changePercent;
  int avgTotalVolume;
  int marketCap;
  double peRatio;
  double ytdChange;

  DbQuote({
    this.symbol,
    this.companyName,
    this.primaryExchange,
    this.sector,
    this.calculationPrice,
    this.open,
    this.close,
    this.high,
    this.low,
    this.latestPrice,
    this.latestSource,
    this.latestTime,
    this.latestUpdate,
    this.latestVolume,
    this.previousClose,
    this.change,
    this.changePercent,
    this.avgTotalVolume,
    this.marketCap,
    this.peRatio,
  });



  factory DbQuote.fromMap(Map<String, dynamic> json) => new DbQuote(
    symbol: json["symbol"].toString().toUpperCase(),
    companyName: json["companyName"],
    primaryExchange: json["primaryExchange"],
    sector: json["sector"],
    calculationPrice: json["calculationPrice"],
    open: json["open"]==null?null:json["open"].toDouble(),
    close: json["close"]==null?null:json["close"].toDouble(),
    high: json["high"]==null?null:json["high"].toDouble(),
    low: json["low"]==null?null:json["low"].toDouble(),
    latestPrice: json["latestPrice"].toDouble(),
    latestSource: json["latestSource"],
    latestTime: json["latestTime"],
    latestUpdate: json["latestUpdate"],
    latestVolume: json["latestVolume"],
    previousClose: json["previousClose"]==null?null:json["previousClose"].toDouble(),
    change: json["change"]==null?null:json["change"].toDouble(),
    changePercent: json["changePercent"]==null?null:json["changePercent"].toDouble(),
    marketCap: json["marketCap"],
    peRatio: json["peRatio"]==null?null:json["peRatio"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "symbol": symbol,
    "companyName": companyName,
    "primaryExchange": primaryExchange,
    "sector": sector,
    "calculationPrice": calculationPrice,
    "open": open,
    "openTime": openTime,
    "close": close,
    "closeTime": closeTime,
    "high": high,
    "low": low,
    "latestPrice": latestPrice,
    "latestSource": latestSource,
    "latestTime": latestTime,
    "latestUpdate": latestUpdate,
    "latestVolume": latestVolume,
    "previousClose": previousClose,
    "change": change,
    "changePercent": changePercent,
    "avgTotalVolume": avgTotalVolume,
    "marketCap": marketCap,
    "peRatio": peRatio,
    "ytdChange": ytdChange,
  };
  Map<String, dynamic> toMapRequired() => {
      "symbol":symbol,
      "companyName":companyName,
      "sector":sector,
      "primaryExchange":primaryExchange,
      "open":open,
      "close":close,
      "high":high,
      "low":low,
      "latestPrice":latestPrice,
      "latestSource":latestSource,
      "previousClose":previousClose,
      "change":change,
      "changePercent":changePercent,
      "marketCap":marketCap,
      "peRatio":peRatio
  };
}
