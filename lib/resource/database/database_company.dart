import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class DbProviderCompany {
  DbProviderCompany._();
  static final DbProviderCompany db = DbProviderCompany._();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + 'my.db';
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Company ("
          "companyName TEXT,"
          "symbol TEXT,"
          "primaryExchange TEXT,"
          "sector TEXT,"
          "latestPrice TEXT,"
          "latestTime TEXT,"
          "change TEXT"
          ")");
    });
  }

  Future<int> newCompany(DBCompany newCompany) async {
    final db = await database;
    var res = db.insert("Company", newCompany.toMap());
    return res;
  }

  Future<List<DBCompany>> getAllCompany() async {
    final db = await database;
    var res = await db.query('Company');
/*    return DBCompany(
        companyName: res[0]['companyName'],
        symbol: res[0]['symbol'],
        primaryExchange: res[0]['primaryExchange'],
        sector: res[0]['sector'],
        latestPrice: double.parse(res[0]['latestPrice']),
        latestTime: res[0]['latestTime'],
        change: double.parse(res[0]['change'])
    );*/
    return List.generate(res.length, (i) {
      return DBCompany(
          companyName: res[i]['companyName'],
          symbol: res[i]['symbol'],
          primaryExchange: res[i]['primaryExchange'],
          sector: res[i]['sector'],
          latestPrice: double.parse(res[i]['latestPrice']),
          latestTime: res[i]['latestTime'],
          change: double.parse(res[i]['change']));
    });
  }

/*  Future<DBCompany> getCompany(String symbol) async {
    final db = await database;
    var res = await db.query("Company", where: "Symbol=?", whereArgs: [symbol]);
    return res.isNotEmpty ? DBCompany.fromMap(res.first) : null;
  }*/
}

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

DBCompany dbCompanyFromJson(String str) {
  final jsonData = json.decode(str);
  return DBCompany.fromJson(jsonData);
}

String dbCompanyToJson(DBCompany data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class DBCompany {
  String symbol;
  String companyName;
  String primaryExchange;
  String sector;
  double latestPrice;
  String latestTime;
  double change;

  DBCompany({
    this.symbol,
    this.companyName,
    this.primaryExchange,
    this.sector,
    this.latestPrice,
    this.latestTime,
    this.change,
  });
  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'companyName': companyName,
      'primaryExchange': primaryExchange,
      'sector': sector,
      'latestPrice': latestPrice,
      'latestTime': latestTime,
      'change': change
    };
  }

  factory DBCompany.fromJson(Map<String, dynamic> json) => new DBCompany(
        symbol: json["symbol"],
        companyName: json["companyName"],
        primaryExchange: json["primaryExchange"],
        sector: json["sector"],
        latestPrice: json["latestPrice"] * 1.0,
        latestTime: json["latestTime"],
        change: json["change"] * 1.0,
      );

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'companyName': companyName,
        'primaryExchange': primaryExchange,
        'sector': sector,
        'latestPrice': latestPrice,
        'latestTime': latestTime,
        'change': change,
      };
/*  factory DBCompany.fromMap(Map<String,dynamic> data) => new DBCompany(
    symbol: data['symbol'],
    companyName: data['companyName'],
    primaryExchange: data[]
  );*/
}

class DBCompanyList {
  final List<DBCompany> dbCompany;

  DBCompanyList({this.dbCompany});

  factory DBCompanyList.fromJson(List<dynamic> parsedJson) {
    List<DBCompany> dbCompany = new List<DBCompany>();
    dbCompany = parsedJson.map((i) => DBCompany.fromJson(i)).toList();
    return new DBCompanyList(dbCompany: dbCompany);
  }
}
