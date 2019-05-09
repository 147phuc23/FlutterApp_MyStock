// To parse this JSON data, do
//
//     final dbSymbol = dbSymbolFromJson(jsonString);

import 'dart:convert';
import './database_interface_data_tranform.dart';

List<DbSymbol> dbSymbolFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<DbSymbol>.from(jsonData.map((x) => DbSymbol.fromMap(x)));
}

class DbSymbol implements DataTranform{
  String symbol;
  String name;
  DateTime date;
  bool isEnabled;
  Type type;
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
        type: typeValues.map[data["type"]],
        iexId: data["iexId"].toString(),
      );

  Map<String, dynamic> toMap() {
    return {
      "symbol": symbol,
      "name": name,
      "date":
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      "isEnabled": isEnabled,
      "type": typeValues.reverse[type],
      "iexId": iexId,
    };
  }
}

enum Type { CS, N_A, ET, PS, SU, BO, CRYPTO }

final typeValues = new EnumValues({
  "bo": Type.BO,
  "crypto": Type.CRYPTO,
  "cs": Type.CS,
  "et": Type.ET,
  "N/A": Type.N_A,
  "ps": Type.PS,
  "su": Type.SU
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
