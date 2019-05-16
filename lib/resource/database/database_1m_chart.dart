// To parse this JSON data, do
//
//     final dbChart1M = dbChart1MFromJson(jsonString);

import 'dart:convert';


List<DbChart1M> dbChart1MFromJson(String str) => new List<DbChart1M>.from(json.decode(str).map((x) => DbChart1M.fromMap(x)));

class DbChart1M {
  DateTime date;
  double open;
  double high;
  double low;
  double close;
  int volume;
  int unadjustedVolume;
  double change;
  double changePercent;
  double vwap;
  String label;
  double changeOverTime;

  DbChart1M({
    this.date,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
    this.unadjustedVolume,
    this.change,
    this.changePercent,
    this.vwap,
    this.label,
    this.changeOverTime,
  });

  factory DbChart1M.fromMap(Map<String, dynamic> json) => new DbChart1M(
    date: json["date"]==null?null:DateTime.parse(json["date"]),
    open: json["open"]==null?null:json["open"].toDouble(),
    high: json["high"]==null?null:json["high"].toDouble(),
    low: json["low"]==null?null:json["low"].toDouble(),
    close: json["close"]==null?null:json["close"].toDouble(),
    volume: json["volume"]==null?null:json["volume"].toInt(),
    unadjustedVolume: json["unadjustedVolume"]==null?null:json["unadjustedVolume"].toInt(),
    change: json["change"]==null?null:json["change"].toDouble(),
    changePercent: json["changePercent"]==null?null:json["changePercent"].toDouble(),
    vwap: json["vwap"]==null?null:json["vwap"].toDouble(),
    label: json["label"],
    changeOverTime: json["changeOverTime"]==null?null:json["changeOverTime"].toDouble(),
  );
  Map<String, dynamic> toMap() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "open": open,
    "high": high,
    "low": low,
    "close": close,
    "volume": volume,
    "change": change,
    "changePercent": changePercent,
    "vwap": vwap,
    "label": label,
    "changeOverTime": changeOverTime,
  };
  Map<String, dynamic> toMapRequired() => {
    "open": open,
    "high": high,
    "low": low,
    "close": close,
    "volumeto": volume,
  };
}
