//Import library
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:sqflite/sqlite_api.dart';
import 'package:http/http.dart' as http;

//Library written
import './database_stock_exchange.dart';
import './database_company_infor.dart';
import './database_symbol.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider db = DbProvider._();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    await initializeDatabase();
    var checkDb = await _database.query("Symbol",
        where: "symbol=?", whereArgs: ["alreadyBeenInitialize"]);
    if (checkDb.isEmpty)
      _database.insert("Symbol", {"symbol": "alreadyBeenInitialize"});
    checkDb = await _database.query("StockExchange",
        where: "mic=?", whereArgs: ["alreadyBeenInitialize"]);
    if (checkDb.isEmpty)
      _database.insert("StockExchange", {"mic": "alreadyBeenInitialize"});
    return _database;
  }

  initializeDatabase() async {
    await initializeAllStockExchange();
    await initializeAllSymbol();
  }

  checkTableExist() async {
    final db = await database;
    var f = await db.rawQuery(
        "SELECT * FROM sqlite_master WHERE name ='Symbol' and type='table'; ");
    print("Check if table already existed");
    print(f);
  }

  List<DbStockExchange> _listOfStockExchange;
  List<DbCompanyInfor> _listOfCompanyInfor;
  List<DbSymbol> _listOfSymbol;

  initDB() async {
    print("Init DB");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + 'my.db';
    var fileExists = new File(path).existsSync() ||
        new Directory(path).existsSync() ||
        new Link(path).existsSync();
    if (fileExists) {
      return openDatabase(path, version: 1);
    }
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS StockExchange ("
          "venueName TEXT,"
          "mic TEXT,"
          "tapeId TEXT,"
          "volume TEXT,"
          "tapeA TEXT,"
          "tapeB TEXT,"
          "tapeC TEXT,"
          "marketPercent TEXT,"
          "lastUpdated TEXT"
          ")");
      await db.execute("CREATE TABLE IF NOT EXISTS Symbol ("
          "symbol TEXT,"
          "name TEXT,"
          "date TEXT,"
          "isEnabled TEXT,"
          "type TEXT,"
          "iexId TEXT"
          ")");
      await db.execute("CREATE TABLE IF NOT EXISTS CompanyInfo ("
          "symbol TEXT,"
          "companyName TEXT,"
          "exchange TEXT,"
          "industry TEXT,"
          "website TEXT,"
          "description TEXT,"
          "ceo TEXT,"
          "issueType TEXT,"
          "sector TEXT,"
          "tag1 TEXT,"
          "tag2 TEXT,"
          "tag3 TEXT"
          ")");
    });
  }

  updateAllStockExchange() async {
    String urlJson = "https://api.iextrading.com/1.0/market";
    http.Response jsonResponse = await http.get(urlJson);
    List<DbStockExchange> listStockExchange =
        dbStockExchangeFromJson(jsonResponse.body);
    _listOfStockExchange = listStockExchange;
    final db = await database;
    for (var f in listStockExchange) {
      if (f != null) {
        var res = await db.update("StockExchange", f.toMap(),
            where: "mic = ?", whereArgs: [f.mic]);
      }
    }
  }

  initializeAllStockExchange() async {
    final db = await database;
    List<Map<String, dynamic>> checkDb = await db.query("StockExchange",
        where: "mic=?", whereArgs: ["alreadyBeenInitialize"]);
    if (checkDb.isNotEmpty) {
      print("Stock Exchange database already been initialized");
      return null;
    }
    ;
    print("Initialize Stock Exchange");
    String urlJson = "https://api.iextrading.com/1.0/market";
    http.Response jsonResponse = await http.get(urlJson);
    List<DbStockExchange> listStockExchange =
        dbStockExchangeFromJson(jsonResponse.body);
    _listOfStockExchange = listStockExchange;

    for (var f in listStockExchange) {
      if (f != null) {
        var res = await db.insert("StockExchange", f.toMap());
      }
    }
  }

  updateAllSymbol() async {
    String urlJson = "https://api.iextrading.com/1.0/ref-data/symbols";
    http.Response jsonResponse = await http.get(urlJson);
    List<DbSymbol> listSymbols = dbSymbolFromJson(jsonResponse.body);
    _listOfSymbol = listSymbols;
    final db = await database;
    for (var f in listSymbols) {
      if (f != null) {
        var res = await db.update("Symbol", f.toMap(),
            where: "symbol = ?", whereArgs: [f.symbol]);
        if(res==0) {
          var res1 = await db.insert("Symbol", f.toMap());
        }
      }
    }
  }

  initializeAllSymbol() async {
    final db = await database;
    List<Map<String, dynamic>> checkDb = await db.query("Symbol",
        where: "symbol=?", whereArgs: ["alreadyBeenInitialize"]);
    if (checkDb.isNotEmpty) {
      print("Symbol database already been initialized");
      return null;
    }

    print("Initialize Symbols");
    String urlJson = "https://api.iextrading.com/1.0/ref-data/symbols";
    http.Response jsonResponse = await http.get(urlJson);
    List<DbSymbol> listSymbols = dbSymbolFromJson(jsonResponse.body);
    _listOfSymbol = listSymbols;
    for (var f in listSymbols) {
      if (f != null) {
        var res = await db.insert("Symbol", f.toMap());
      }
    }
  }

  getAllStockExchange() async {
    final db = await database;
    var res = await db.query("StockExchange");
    return res.isEmpty ? null : res;
  }

  getAllSymbol() async {
    final db = await database;
    var res = await db.query("Symbol");
    return res.isEmpty ? null : res;
  }

  getStockExchange(String mic) async {
    final db = await database;
    var res =
        await db.query("StockExchange", where: "mic= ?", whereArgs: [mic]);
    return res.isNotEmpty ? res.first : null;
  }

  searchSymbol(String symbol) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Symbol WHERE symbol LIKE '%$symbol%'");
    return res;
  }

  getCompanyInfo(String symbol) async {
    final db = await database;
    String urlJson = "https://api.iextrading.com/1.0/stock/$symbol/company";
    var checkDb =
        await db.query("CompanyInfo", where: "symbol=?", whereArgs: [symbol]);
    if (checkDb.isEmpty) {
      http.Response jsonResponse = await http.get(urlJson);
      if (jsonResponse.body.toLowerCase() == "unknown symbol") {
        throw ("Wrong Symbol");
      }
      DbCompanyInfor info = dbCompanyInforFromJson(jsonResponse.body);
      db.insert("CompanyInfo", info.toMapDatabase());
      return info.toMapDatabase();
    } else {
      print("Company $symbol already in database");
      return checkDb.first;
    }
  }

  getChartInfo_1m(String symbol) async {
    final db = await database;
  }
}
