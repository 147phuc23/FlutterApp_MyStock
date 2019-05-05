//Import library
import 'dart:async';


import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:sqflite/sqlite_api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//Library written
import './database_stock_exchange.dart';
import './database_company_infor.dart';
import './database_symbol.dart';
import './database_1m_chart.dart';
import './database_1d_chart.dart';
import './database_quote.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider db = DbProvider._();
  static Database _database;

  //Getter lay doi tuong database
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

  //Ham goi khoi tao cho database
  initializeDatabase() async {
    await initializeAllStockExchange();
    await initializeAllSymbol();
  }


  //Ham dung de debug khong su dung !!!
  //Kiem tra xem table trong database da duoc tao chua
  checkTableExist() async {
    final db = await database;
    var f = await db.rawQuery(
        "SELECT * FROM sqlite_master WHERE name ='Symbol' and type='table'; ");
    print("Check if table already existed");
    print(f);
  }

  //Ham khoi tao cho getter
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

  //Ham du phong, dung de cap nhat lai cho table StockExchange
  updateAllStockExchange() async {
    String urlJson = "https://api.iextrading.com/1.0/market";
    http.Response jsonResponse = await http.get(urlJson);
    List<DbStockExchange> listStockExchange =
        dbStockExchangeFromJson(jsonResponse.body);
    final db = await database;
    for (var f in listStockExchange) {
      if (f != null) {
        var res = await db.update("StockExchange", f.toMap(),
            where: "mic = ?", whereArgs: [f.mic]);
      }
    }
  }

  //Ham khoi tao cho table StockExchange
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

    for (var f in listStockExchange) {
      if (f != null) {
        var res = await db.insert("StockExchange", f.toMap());
      }
    }
  }

  //Ham du phong, dung de cap nhat cho table Symbol
  updateAllSymbol() async {
    String urlJson = "https://api.iextrading.com/1.0/ref-data/symbols";
    http.Response jsonResponse = await http.get(urlJson);
    List<DbSymbol> listSymbols = dbSymbolFromJson(jsonResponse.body);
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

  //Ham khoi tao cho table Symbol
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
    for (var f in listSymbols) {
      if (f != null) {
        var res = await db.insert("Symbol", f.toMap());
      }
    }
  }





  //Tu day tro di la cac ham tra data ve









  //Ham tra ve tat ca StockExchange ma API ho tro
  //Map<String,dynamic> duoc tra ve co dang:
  //{
  //  //      "mic": mic,
  //  //      "tapeId": tapeId,
  //  //      "venueName": venueName,
  //  //      "volume": volume,
  //  //      "tapeA": tapeA,
  //  //      "tapeB": tapeB,
  //  //      "tapeC": tapeC,
  //  //      "marketPercent": marketPercent,
  //  //      "lastUpdated": lastUpdated
  //  //    };
  Future<List<Map<String,dynamic>>> getAllStockExchange() async {
    final db = await database;
    var res = await db.query("StockExchange");
    return res.isEmpty ? null : res;
  }

  //Ham dung tra ve tat ca symbols ma API ho tro
  //Map<String,dynamic> duoc tra ve co dang:
  //{
  //      "symbol": symbol,
  //      "name": name,
  //      "date":dateTime, (co dang YYYYMMDD)
  //      "isEnabled": isEnabled,
  //      "type": typeValues.reverse[type],
  //      "iexId": iexId,
  //    };
  Future<List<Map<String,dynamic>>> getAllSymbol() async {
    final db = await database;
    var res = await db.query("Symbol");
    return res.isEmpty ? null : res;
  }

  //Ham tra ve thong tin cua san chung khoan (StockExchange), nhan vao ma san (mic)
  //Map<String,dynamic> duoc tra ve co dang:
  //{
  //      "mic": mic,
  //      "tapeId": tapeId,
  //      "venueName": venueName,
  //      "volume": volume,
  //      "tapeA": tapeA,
  //      "tapeB": tapeB,
  //      "tapeC": tapeC,
  //      "marketPercent": marketPercent,
  //      "lastUpdated": lastUpdated
  //    };
  Future<List<Map<String,dynamic>>> searchStockExchange(String mic) async {
    final db = await database;
    var res =
        await db.query("StockExchange", where: "mic= ?", whereArgs: [mic]);
    return res.isNotEmpty ? res : null;
  }

  //Ham dung de tim kiem thong tin symbols, nhan vao 1 chuoi ky tu
  //Ham se tim kiem trong database cac symbol co chua cac ky tu nhan vao
  //Map<String,dynamic> duoc tra ve co dang
  //{
  //      "symbol": symbol,
  //      "name": name,
  //      "date":dateTime, (co dang YYYYMMDD)
  //      "isEnabled": isEnabled,
  //      "type": typeValues.reverse[type],
  //      "iexId": iexId,
  //    };
  Future<List<Map<String,dynamic>>> searchSymbol(String symbol) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Symbol WHERE symbol LIKE '%$symbol%'");
    return res.isNotEmpty?res:null;
  }

  //Ham dung de lay thong tin chi tiet ve cong ty dua vao symbol nhan vao
  //Luu y: ham se chi tra ve thong tin chi tiet cua cong ty khi nhan vao symbol chinh xac
  //Map<String,dynamic> duoc tra ve co dang
  //{
  //      "symbol": symbol,
  //      "companyName": companyName,
  //      "exchange": exchange,
  //      "industry": industry,
  //      "website": website,
  //      "description": description,
  //      "CEO": ceo,
  //      "issueType": issueType,
  //      "sector": sector,
  //      "tag1": tags.length>1?tags[0]:null,
  //      "tag2" : tags.length>2?tags[1]:null,
  //      "tag3": tags.length>3?tags[2]:null
  // };
  Future<Map<String,dynamic>> getCompanyInfo(String symbol) async {
    final db = await database;
    String urlJson = "https://api.iextrading.com/1.0/stock/$symbol/company";
    var checkDb =
        await db.query("CompanyInfo", where: "symbol=?", whereArgs: [symbol]);
    if (checkDb.isEmpty) {
      http.Response jsonResponse = await http.get(urlJson);
      if (jsonResponse.body.toLowerCase() == "unknown symbol") {
        return null;
      }
      DbCompanyInfor info = dbCompanyInforFromJson(jsonResponse.body);
      db.insert("CompanyInfo", info.toMapDatabase());
      return info.toMapDatabase();
    } else {
      print("Company $symbol already in database");
      return checkDb.first;
    }
  }

  //Ham tra ve thong tin chung khoan cua cong ty trong 1 thang
  //Luu y: Ham chi nhan vao chinh xac symbol
  //{
  //    "open": open,
  //    "high": high,
  //    "low": low,
  //    "close": close,
  //    "volume": volume,
  //  };
  Future<List<Map<String,dynamic>>> getChartInfo_1m(String symbol) async {
    var db = await database;
    List<Map<String, dynamic>> checkSymbol = await db.query(
        "Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      return null;
    } else{
      if(DbSymbol.fromMap(checkSymbol.first).isEnabled==false){
        return null;
      }
    }
    String urlJson = "https://api.iextrading.com/1.0/stock/${symbol}/chart/1m";
    http.Response response = await http.get(urlJson);
    List<DbChart1M> chart = dbChart1MFromJson(response.body);
    chart.sort((a, b) => a.date.compareTo(b.date));
    List<Map<String, dynamic>> chartMap= new List<Map<String,dynamic>>();
    for (int i = 0; i < chart.length; i++) {
      chartMap.add(chart[i].toMapRequired());
    }
    return chartMap.isNotEmpty ? chartMap : [];
  }

  //Ham tra ve thong tin chung khoan cua cong ty trong 1 ngay
  //Luu y: Ham chi nhan vao chinh xac symbol
  //Map<String,dynamic> duoc tra ve theo dang
  //{
  //    "high": high,
  //    "low": low,
  //    "volume": volume,
  //    "open": open,
  //    "close": close,
  //  };
  Future<List<Map<String,dynamic>>> getChartInfo_1d(String symbol) async {
    var db = await database;
    List<Map<String, dynamic>> checkSymbol = await db.query(
        "Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      return null;
    } else{
      if(DbSymbol.fromMap(checkSymbol.first).isEnabled==false){
        return null;
      }
    }
    String urlJson = "https://api.iextrading.com/1.0/stock/${symbol}/chart/1d?chartInterval=10";
    http.Response response = await http.get(urlJson);
    List<DbChart1D> chart = dbChart1DFromJson(response.body);
    List<Map<String, dynamic>> chartMap=new List<Map<String,dynamic>>() ;
    for (int i = 0; i < chart.length; i++) {
      if(chart[i]!=null)
        chartMap.add(chart[i].toMapRequired());
    }
    return chartMap.isNotEmpty ? chartMap : [];
  }

  //Ham tra ve thong tin chung khoan cua cong ty trong 3 ngay
  //Luu y: Ham chi nhan vao chinh xac symbol
  //Map<String,dynamic> duoc tra ve theo dang:
  //{
  //    "high": high,
  //    "low": low,
  //    "volume": volume,
  //    "open": open,
  //    "close": close,
  // };
  Future<List<Map<String,dynamic>>> getChartInfo_3d(String symbol) async {
    var db = await database;
    List<Map<String, dynamic>> checkSymbol = await db.query(
        "Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      return null;
    } else{
      if(DbSymbol.fromMap(checkSymbol.first).isEnabled==false){
        return null;
      }
    }
    DateTime time= new DateTime.now();
    time = time.subtract(new Duration(days:2));
    var formatter= new DateFormat('yyyyMMdd');
    String dateFormatter= formatter.format(time);
    String urlJson = "https://api.iextrading.com/1.0/stock/$symbol/chart/date/$dateFormatter?chartInterval=10";
    http.Response response = await http.get(urlJson);
    List<DbChart1D> chart = dbChart1DFromJson(response.body);
    List<Map<String, dynamic>> chartMap=new List<Map<String,dynamic>>() ;
    for (int i = 0; i < chart.length; i++) {
      if(chart[i]!=null)
        chartMap.add(chart[i].toMapRequired());
    }
    time=DateTime.now();
    time=time.subtract(new Duration(days:1));
    dateFormatter= formatter.format(time);
    urlJson = "https://api.iextrading.com/1.0/stock/$symbol/chart/date/$dateFormatter?chartInterval=10";
    response = await http.get(urlJson);
    chart = dbChart1DFromJson(response.body);
    for (int i = 0; i < chart.length; i++) {
      if(chart[i]!=null)
        chartMap.add(chart[i].toMapRequired());
    }
    urlJson = "https://api.iextrading.com/1.0/stock/$symbol/chart/1d?chartInterval=10";
    response = await http.get(urlJson);
    chart = dbChart1DFromJson(response.body);
    for (int i = 0; i < chart.length; i++) {
      if(chart[i]!=null)
        chartMap.add(chart[i].toMapRequired());
    }
    return chartMap.isNotEmpty ? chartMap : [];
  }

  //Ham tra ve thong tin chung khoan cua cong ty theo thoi gian hien tai
  //Luu y: Ham chi nhan vao chinh xac symbol
  //Ham se tra ve Map<String,dynamic> theo dang:
  // {
  //    "symbol":symbol,
  //    "open": open,
  //    "close": close,
  //    "high": high,
  //    "low": low,
  //    "marketCap": marketCap,
  //    "peRatio": peRatio,
  //  };
  Future<Map<String,dynamic>> getRealTimeInfo(String symbol) async{
    var db=await database;
    List<Map<String, dynamic>> checkSymbol = await db.query(
        "Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      return null;
    } else{
      if(checkSymbol.first["isEnabled"].toString().toLowerCase()=="false"){
        return null;
      }
    }
    String urlJson ="https://api.iextrading.com/1.0/stock/$symbol/quote";
    http.Response response=await http.get(urlJson);
    DbQuote quote = dbQuoteFromJson(response.body);
    print(quote.toMapRequired());
    return quote.toMapRequired();
  }
}
