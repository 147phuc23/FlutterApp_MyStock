// To parse this JSON data, do
//
//     final dbQuote = dbQuoteFromJson(jsonString);

import 'dart:convert';

DbQuote dbQuoteFromJson(String str) => DbQuote.fromJson(json.decode(str));

String dbQuoteToJson(DbQuote data) => json.encode(data.toJson());

class DbQuote {
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
    this.openTime,
    this.close,
    this.closeTime,
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


  factory DbQuote.fromJson(Map<String, dynamic> json) => new DbQuote(
    symbol: json["symbol"],
    companyName: json["companyName"],
    primaryExchange: json["primaryExchange"],
    sector: json["sector"],
    calculationPrice: json["calculationPrice"],
    open: json["open"]==null?0.0:json["open"].toDouble(),
    openTime: json["openTime"]==null?0:json["openTime"].toInt(),
    close: json["close"]==null?0.0:json["close"].toDouble(),
    closeTime: json["closeTime"]==null?0:json["closeTime"].toInt(),
    high: json["high"]==null?0.0:json["high"].toDouble(),
    low: json["low"]==null?0.0:json["low"].toDouble(),
    latestPrice: json["latestPrice"]==null?0.0:json["latestPrice"].toDouble(),
    latestSource: json["latestSource"],
    latestTime: json["latestTime"],
    latestUpdate: json["latestUpdate"]==null?0:json["latestUpdate"].toInt(),
    latestVolume: json["latestVolume"]==null?0:json["latestVolume"].toInt(),
    previousClose: json["previousClose"]==null?0.0:json["previousClose"].toDouble(),
    change: json["change"]==null?0.0:json["change"].toDouble(),
    changePercent: json["changePercent"]==null?0.0:json["changePercent"].toDouble(),
    marketCap: json["marketCap"]==null?0:json["marketCap"].toInt(),
    peRatio: json["peRatio"]==null?0.0:json["peRatio"].toDouble(),
  );
  factory DbQuote.fromMap(Map<String, dynamic> json) => new DbQuote(
    symbol: json["symbol"],
    companyName: json["companyName"],
    primaryExchange: json["primaryExchange"],
    sector: json["sector"],
    calculationPrice: json["calculationPrice"],
    open: json["open"].toDouble(),
    openTime: json["openTime"],
    close: json["close"].toDouble(),
    closeTime: json["closeTime"],
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    latestPrice: json["latestPrice"].toDouble(),
    latestSource: json["latestSource"],
    latestTime: json["latestTime"],
    latestUpdate: json["latestUpdate"],
    latestVolume: json["latestVolume"],
    previousClose: json["previousClose"].toDouble(),
    change: json["change"].toDouble(),
    changePercent: json["changePercent"].toDouble(),
    marketCap: json["marketCap"],
    peRatio: json["peRatio"].toDouble(),
  );
  Map<String, dynamic> toJson() => {
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
    "open": open,
    "close": close,
    "high": high,
    "low": low,
    "marketCap": marketCap,
    "peRatio": peRatio,
  };
}
