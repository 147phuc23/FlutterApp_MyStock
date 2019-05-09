// To parse this JSON data, do
//
//     final dbChart1M = dbChart1MFromJson(jsonString);

import 'dart:convert';
import './database_interface_data_tranform.dart';

List<DbChart1M> dbChart1MFromJson(String str) => new List<DbChart1M>.from(json.decode(str).map((x) => DbChart1M.fromJson(x)));

class DbChart1M implements DataTranform {
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

  factory DbChart1M.fromJson(Map<String, dynamic> json) => new DbChart1M(
    date: DateTime.parse(json["date"]),
    open: json["open"].toDouble(),
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    close: json["close"].toDouble(),
    volume: json["volume"],
    unadjustedVolume: json["unadjustedVolume"],
    change: json["change"].toDouble(),
    changePercent: json["changePercent"].toDouble(),
    vwap: json["vwap"].toDouble(),
    label: json["label"],
    changeOverTime: json["changeOverTime"].toDouble(),
  );
  factory DbChart1M.fromMap(Map<String, dynamic> json) => new DbChart1M(
    date: DateTime.parse(json["date"]),
    open: json["open"].toDouble(),
    high: json["high"].toDouble(),
    low: json["low"].toDouble(),
    close: json["close"].toDouble(),
    volume: json["volume"],
    unadjustedVolume: json["unadjustedVolume"],
    change: json["change"].toDouble(),
    changePercent: json["changePercent"].toDouble(),
    vwap: json["vwap"].toDouble(),
    label: json["label"],
    changeOverTime: json["changeOverTime"].toDouble(),
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
    "volume": volume,
  };
}
