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
  double open;
  double close;
  double changeOverTime;


  DbChart1D({
    this.date,
    this.minute,
    this.label,
    this.high,
    this.low,
    this.average,
    this.volume,
    this.open,
    this.close,
    this.changeOverTime,
  });

  factory DbChart1D.fromJson(Map<String, dynamic> json) => new DbChart1D(
    date: json["date"],
    minute: json["minute"],
    label: json["label"],
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    average: json["average"].toDouble(),
    volume: json["volume"],
    open: json["open"].toDouble(),
    close: json["close"].toDouble(),
    changeOverTime: json["changeOverTime"].toDouble(),
  );
  factory DbChart1D.fromMap(Map<String, dynamic> json) => new DbChart1D(
    date: json["date"],
    minute: json["minute"],
    label: json["label"],
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    average: json["average"].toDouble(),
    volume: json["volume"],
    open: json["open"].toDouble(),
    close: json["close"].toDouble(),
    changeOverTime: json["changeOverTime"].toDouble(),

  );
  Map<String, dynamic> toJson() => {
    "date": date,
    "minute": minute,
    "label": label,
    "high": high,
    "low": low,
    "average": average,
    "volume": volume,
    "open": open,
    "close": close,
    "changeOverTime": changeOverTime,
  };
  Map<String, dynamic> toMap() => {
    "date": date,
    "minute": minute,
    "label": label,
    "high": high,
    "low": low,
    "average": average,
    "volume": volume,
    "open": open,
    "close": close,
    "changeOverTime": changeOverTime,
  };
  Map<String, dynamic> toMapRequired() => {
    "high": high,
    "low": low,
    "volume": volume,
    "open": open,
    "close": close,
  };
}
