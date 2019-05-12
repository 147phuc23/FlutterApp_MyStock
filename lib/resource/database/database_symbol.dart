// To parse this JSON data, do
//
//     final dbSymbol = dbSymbolFromJson(jsonString);

import 'dart:convert';

List<DbSymbol> dbSymbolFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<DbSymbol>.from(jsonData.map((x) => DbSymbol.fromMap(x)));
}

class DbSymbol {
  String symbol;
  String name;
  DateTime date;
  bool isEnabled;
  String type;
  dynamic iexId;

  DbSymbol({
    this.symbol,
    this.name,
    this.date,
    this.isEnabled,
    this.type,
    this.iexId,
  });


  factory DbSymbol.fromMap(Map<String, dynamic> data) => new DbSymbol(
        symbol: data["symbol"],
        name: data["name"],
        date: DateTime.parse(data["date"]),
        isEnabled: data["isEnabled"].toString().toLowerCase()=="true",
        type: data["type"],
        iexId: data["iexId"].toString(),
      );

  Map<String, dynamic> toMap() {
    return {
      "symbol": symbol,
      "name": name,
      "date":
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      "isEnabled": isEnabled,
      "type": type,
      "iexId": iexId,
    };
  }
}


