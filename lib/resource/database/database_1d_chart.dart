// To parse this JSON data, do
//
//     final dbChart1D = dbChart1DFromJson(jsonString);

import 'dart:convert';

List<DbChart1D> dbChart1DFromJson(String str) => new List<DbChart1D>.from(json.decode(str).map((x) => DbChart1D.fromJson(x)));

String dbChart1DToJson(List<DbChart1D> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class DbChart1D {
  String date;
  String minute;
  String label;
  double high;
  double low;
  double average;
  int volume;
  double notional;
  int numberOfTrades;
  double marketHigh;
  double marketLow;
  double marketAverage;
  int marketVolume;
  double marketNotional;
  int marketNumberOfTrades;
  double open;
  double close;
  double marketOpen;
  double marketClose;
  double changeOverTime;
  double marketChangeOverTime;

  DbChart1D({
    this.date,
    this.minute,
    this.label,
    this.high,
    this.low,
    this.average,
    this.volume,
    this.notional,
    this.numberOfTrades,
    this.marketHigh,
    this.marketLow,
    this.marketAverage,
    this.marketVolume,
    this.marketNotional,
    this.marketNumberOfTrades,
    this.open,
    this.close,
    this.marketOpen,
    this.marketClose,
    this.changeOverTime,
    this.marketChangeOverTime,
  });

  factory DbChart1D.fromJson(Map<String, dynamic> json) => new DbChart1D(
    date: json["date"],
    minute: json["minute"],
    label: json["label"],
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    average: json["average"].toDouble(),
    volume: json["volume"],
    notional: json["notional"].toDouble(),
    numberOfTrades: json["numberOfTrades"],
    marketHigh: json["marketHigh"].toDouble(),
    marketLow: json["marketLow"].toDouble(),
    marketAverage: json["marketAverage"].toDouble(),
    marketVolume: json["marketVolume"],
    marketNotional: json["marketNotional"].toDouble(),
    marketNumberOfTrades: json["marketNumberOfTrades"],
    open: json["open"].toDouble(),
    close: json["close"].toDouble(),
    marketOpen: json["marketOpen"].toDouble(),
    marketClose: json["marketClose"].toDouble(),
    changeOverTime: json["changeOverTime"].toDouble(),
    marketChangeOverTime: json["marketChangeOverTime"].toDouble(),
  );
  factory DbChart1D.fromMap(Map<String, dynamic> json) => new DbChart1D(
    date: json["date"],
    minute: json["minute"],
    label: json["label"],
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    average: json["average"].toDouble(),
    volume: json["volume"],
    notional: json["notional"].toDouble(),
    numberOfTrades: json["numberOfTrades"],
    marketHigh: json["marketHigh"].toDouble(),
    marketLow: json["marketLow"].toDouble(),
    marketAverage: json["marketAverage"].toDouble(),
    marketVolume: json["marketVolume"],
    marketNotional: json["marketNotional"].toDouble(),
    marketNumberOfTrades: json["marketNumberOfTrades"],
    open: json["open"].toDouble(),
    close: json["close"].toDouble(),
    marketOpen: json["marketOpen"].toDouble(),
    marketClose: json["marketClose"].toDouble(),
    changeOverTime: json["changeOverTime"].toDouble(),
    marketChangeOverTime: json["marketChangeOverTime"].toDouble(),
  );
  Map<String, dynamic> toJson() => {
    "date": date,
    "minute": minute,
    "label": label,
    "high": high,
    "low": low,
    "average": average,
    "volume": volume,
    "notional": notional,
    "numberOfTrades": numberOfTrades,
    "marketHigh": marketHigh,
    "marketLow": marketLow,
    "marketAverage": marketAverage,
    "marketVolume": marketVolume,
    "marketNotional": marketNotional,
    "marketNumberOfTrades": marketNumberOfTrades,
    "open": open,
    "close": close,
    "marketOpen": marketOpen,
    "marketClose": marketClose,
    "changeOverTime": changeOverTime,
    "marketChangeOverTime": marketChangeOverTime,
  };
  Map<String, dynamic> toMap() => {
    "date": date,
    "minute": minute,
    "label": label,
    "high": high,
    "low": low,
    "average": average,
    "volume": volume,
    "notional": notional,
    "numberOfTrades": numberOfTrades,
    "marketHigh": marketHigh,
    "marketLow": marketLow,
    "marketAverage": marketAverage,
    "marketVolume": marketVolume,
    "marketNotional": marketNotional,
    "marketNumberOfTrades": marketNumberOfTrades,
    "open": open,
    "close": close,
    "marketOpen": marketOpen,
    "marketClose": marketClose,
    "changeOverTime": changeOverTime,
    "marketChangeOverTime": marketChangeOverTime,
  };
  Map<String, dynamic> toMapRequired() => {
    "high": high,
    "low": low,
    "volume": volume,
    "open": open,
    "close": close,
  };
}
