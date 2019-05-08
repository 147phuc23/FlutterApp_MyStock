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
import './database_company_info.dart';
import './database_symbol.dart';
import './database_1m_chart.dart';
import './database_1d_chart.dart';
import './database_quote.dart';
import './database_top_symbols.dart';

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
      await db.execute("CREATE TABLE IF NOT EXISTS  FavoriteList(symbol TEXT)");
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
    try{
      http.Response jsonResponse = await http.get(urlJson);
      List<DbStockExchange> listStockExchange =
      dbStockExchangeFromJson(jsonResponse.body);

      for (var f in listStockExchange) {
        if (f != null) {
          var res = await db.insert("StockExchange", f.toMap());
        }
      }
    }
    catch(e){
      throw "Cannot get data.";
    }

  }

  //Ham du phong, dung de cap nhat cho table Symbol
  updateAllSymbol() async {
    String urlJson = "https://api.iextrading.com/1.0/ref-data/symbols";
    try{
      http.Response jsonResponse = await http.get(urlJson);
      List<DbSymbol> listSymbols = dbSymbolFromJson(jsonResponse.body);
      final db = await database;
      for (var f in listSymbols) {
        if (f != null) {
          var res = await db.update("Symbol", f.toMap(),
              where: "symbol = ?", whereArgs: [f.symbol]);
          if(res==0) {
            await db.insert("Symbol", f.toMap());
          }
        }
      }
    }catch(e){
      throw "Cannot get data";
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
    try{
      http.Response jsonResponse = await http.get(urlJson);
      List<DbSymbol> listSymbols = dbSymbolFromJson(jsonResponse.body);
      for (var f in listSymbols) {
        if (f != null) {
          var res = await db.insert("Symbol", f.toMap());
        }
      }
    }catch(e){
      throw "Cannot get data.";
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
      try {
        http.Response jsonResponse = await http.get(urlJson);
        if (jsonResponse.body.toLowerCase() == "unknown symbol") {
          return null;
        }
        DbCompanyInfor info = dbCompanyInforFromJson(jsonResponse.body);
        db.insert("CompanyInfo", info.toMapDatabase());
        return info.toMapDatabase();
      }
      catch (e) {
        return null;
      }
    }else {
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
    await db.execute("CREATE TABLE IF NOT EXISTS ${symbol.toUpperCase()}_chart_1d ("
        "date TEXT,"
        "minute TEXT,"
        "label TEXT,"
        "high NUMBER,"
        "low NUMBER,"
        "average NUMBER,"
        "volume NUMBER,"
        "open NUMBER,"
        "close NUMBER,"
        "changeOverTime NUMBER"
        ")");
    List<Map<String, dynamic>> checkSymbol = await db.query(
        "Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      return null;
    } else{
      if(DbSymbol.fromMap(checkSymbol.first).isEnabled==false){
        return null;
      }
    }
    var checkDate= await db.query("${symbol.toUpperCase()}_chart_1m",where: "label =?",whereArgs: ["haveData"]);
    String urlJson = "https://api.iextrading.com/1.0/stock/${symbol}/chart/1m";
    try{
      http.Response response = await http.get(urlJson);
      await db.delete("${symbol.toUpperCase()}_chart_1d");
      List<DbChart1M> chart = dbChart1MFromJson(response.body);

      List<Map<String, dynamic>> chartMap= new List<Map<String,dynamic>>();
      for (int i = 0; i < chart.length; i++) {
        if(chart[i]!=null) {
          chartMap.add(chart[i].toMapRequired());
          await db.insert("${symbol.toUpperCase()}_chart_1m", chart[i].toMap());
        }
      }
      return chartMap.isNotEmpty ? chartMap : [];
    }catch(e){
      return null;
    }
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
    await db.execute("CREATE TABLE IF NOT EXISTS ${symbol.toUpperCase()}_chart_1d ("
        "date TEXT,"
        "minute TEXT,"
        "label TEXT,"
        "high NUMBER,"
        "low NUMBER,"
        "average NUMBER,"
        "volume NUMBER,"
        "open NUMBER,"
        "close NUMBER,"
        "changeOverTime NUMBER"
        ")");
    List<Map<String, dynamic>> checkSymbol = await db.query(
        "Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      print("Not have symbol");
      return null;
    } else{
      if(!DbSymbol.fromMap(checkSymbol.first).isEnabled){
        print(DbSymbol.fromMap(checkSymbol.first).isEnabled);
        print("Symbol is not supported");
        return null;
      }
    }
    var checkDate= await db.query("${symbol.toUpperCase()}_chart_1d",where: "label =?",whereArgs: ["haveData"]);
    String urlJson = "https://api.iextrading.com/1.0/stock/${symbol}/chart/1d?chartInterval=10";
    try{
      http.Response response = await http.get(urlJson);
      await db.delete("${symbol.toUpperCase()}_chart_1d");
      List<DbChart1D> chart = dbChart1DFromJson(response.body);
      List<Map<String, dynamic>> chartMap=new List<Map<String,dynamic>>() ;
      for (int i = 0; i < chart.length; i++) {
        if(chart[i]!=null) {
          chartMap.add(chart[i].toMapRequired());
          await db.insert("${symbol.toUpperCase()}_chart_1d", chart[i].toMap());
        }
      }
        await db.insert("${symbol.toUpperCase()}_chart_1d", {
        "label":"haveData"
        });
      return chartMap.isNotEmpty ? chartMap : [];
    }catch(e){
      if(checkDate.isEmpty){
        return null;
      }else{
        List<Map<String,dynamic>> chartData=await db.query("${symbol.toUpperCase()}_chart_1d",where: "label NOT LIKE 'haveData'");
        List<Map<String,dynamic>> chartDataInRequired=new List<Map<String,dynamic>>();
        for(var f in chartData){
          chartDataInRequired.add({
            "high": f["high"],
            "low": f["low"],
            "volume": f["volume"],
            "open": f["open"],
            "close": f["close"],
          });
        }
        return chartDataInRequired;
      }
    }

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
    await db.execute("CREATE TABLE IF NOT EXISTS ${symbol.toUpperCase()}_chart_3d ("
        "date TEXT,"
        "minute TEXT,"
        "label TEXT,"
        "high NUMBER,"
        "low NUMBER,"
        "average NUMBER,"
        "volume NUMBER,"
        "open NUMBER,"
        "close NUMBER,"
        "changeOverTime NUMBER"
        ")");
    var checkDate= await db.query("${symbol.toUpperCase()}_chart_3d",where: "label =?",whereArgs: ["haveData"]);
    List<Map<String, dynamic>> checkSymbol = await db.query(
        "Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      print("Not have symbol");
      return null;
    } else{
      if(!DbSymbol.fromMap(checkSymbol.first).isEnabled){
        print(DbSymbol.fromMap(checkSymbol.first).isEnabled);
        print("Symbol is not supported");
        return null;
      }
    }
    try{

      //Get chart data for 3d latest
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
          chartMap.add(chart[i].toMap());
      }
      time=DateTime.now();
      time=time.subtract(new Duration(days:1));
      dateFormatter= formatter.format(time);
      urlJson = "https://api.iextrading.com/1.0/stock/$symbol/chart/date/$dateFormatter?chartInterval=10";
      response = await http.get(urlJson);
      chart = dbChart1DFromJson(response.body);
      for (int i = 0; i < chart.length; i++) {
        if(chart[i]!=null)
          chartMap.add(chart[i].toMap());
      }
      urlJson = "https://api.iextrading.com/1.0/stock/$symbol/chart/1d?chartInterval=10";
      response = await http.get(urlJson);
      chart = dbChart1DFromJson(response.body);
      for (int i = 0; i < chart.length; i++) {
        if(chart[i]!=null)
          chartMap.add(chart[i].toMap());
      }

      //Add data to database
      List<Map<String,dynamic>> returnChart= [];
      await db.delete("${symbol.toUpperCase()}_chart_3d");
      for (int i = 0; i < chartMap.length; i++) {
        if(chartMap[i]!=null) {
          returnChart.add(DbChart1M.fromMap(chartMap[i]).toMapRequired());
          await db.insert("${symbol.toUpperCase()}_chart_3d", chartMap[i]);
        }
      }
      await db.insert("${symbol.toUpperCase()}_chart_3d", {
        "label":"haveData"
      });
      return chartMap.isNotEmpty ? chartMap : [];
    }catch(e){
      if(checkDate.isEmpty){
        return null;
      }else{
        List<Map<String,dynamic>> chartData=await db.query("${symbol.toUpperCase()}_chart_3d",where: "label NOT LIKE 'haveData'");
        List<Map<String,dynamic>> chartDataInRequired=new List<Map<String,dynamic>>();
        for(var f in chartData){
          chartDataInRequired.add({
            "high": f["high"],
            "low": f["low"],
            "volume": f["volume"],
            "open": f["open"],
            "close": f["close"],
          });
        }
        return chartDataInRequired;
      }
    }
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
    try {
      http.Response response = await http.get(urlJson);
      print("Status code : ${response.statusCode}");
      DbQuote quote = dbQuoteFromJson(response.body);
      return quote.toMapRequired();
    } catch(e){
      print("Can't not connect to the network.");
      return null;
    }
  }

  //Ham tra ve top 10 symbols hoat dong manh nhat
  //Map tra ve:{
  //    "symbol": symbol,
  //    "open": open,
  //    "close": close,
  //    "high": high,
  //    "low": low,
  //    "change": change,
  //    "changePercent": changePercent,
  //    "marketCap": marketCap,
  //    "peRatio": peRatio,
  //  };
  Future<List<Map<String,dynamic>>> getTopSymbols() async{
    var db=await database;
    await db.execute("CREATE TABLE IF NOT EXISTS Top_Symbols ("
        "symbol TEXT,"
        "companyName TEXT,"
        "open NUMBER,"
        "close NUMBER,"
        "high NUMBER,"
        "latestPrice NUMBER,"
        "low NUMBER,"
        "change NUMBER,"
        "changePercent NUMBER,"
        "marketCap NUMBER,"
        "peRatio NUMBER"
        ")");
    var checkDate= await db.query("Top_Symbols",where: "symbol =?",whereArgs: ["haveData"]);
    String urlJson="https://api.iextrading.com/1.0/stock/market/list/mostactive";
    try{
      http.Response response=await http.get(urlJson);
      print("Get Top symbols worked");
      List<DbTopSymbols> topSymbol=dbTopSymbolsFromJson(response.body);
      List<Map<String,dynamic>> returnMap=[];
      await db.delete("Top_Symbols");
      await db.insert("Top_Symbols", {"symbol":"haveData"});
      for(var f in topSymbol){
        if(f!=null) {
          await db.insert("Top_Symbols", f.toMap());
          returnMap.add(f.toMap());
        }
      }
      return returnMap;
    }catch(e){
      if(checkDate.isEmpty){
        return null;
      }else{
        print("Get top symbol workded");
        var data=await db.query("Top_Symbols",where: "symbol NOT LIKE 'haveData'");
        return data;
      }
    }
  }

  //Ham dung de them vao favorite list
  //Ham se tra ve true neu them vao thanh cong hoac symbol da co trong list
  //Tra ve false neu symbol khong duoc ho tro hoac khong co trong list symbol lay tu API
  Future<bool> addToFavoriteList(String symbol) async{
    var db=await database;
    var checkSupported=await db.query("Symbol",where: "symbol=?",whereArgs: [symbol]);
    if(checkSupported.isEmpty){
      return false;
    }else{
      if(checkSupported.first["isEnabled"]=="0"){
        return false;
      }
    }
    var checkDb=await db.query("FavoriteList",where:"symbol=?",whereArgs: [symbol]);
    if(checkDb.isNotEmpty){
      return true;
    }else{
      await db.insert("FavoriteList", {"symbol":symbol});
      return true;
    }
  }

  //Ham dung de xoa 1 symbol ra khoi FavoriteList
  //Ham se tra ve true neu xoa thanh cong
  Future<bool> deleteFromFavoriteList(String symbol)async{
    var db=await database;
    await db.delete("FavoriteList",where: "symbol=?",whereArgs: [symbol]);
    return true;
  }

  //Ham dung de lay tat ca cac symbnol dang co trong Favorite List
  //Ham se tra ve List<String> cac symbol hoac tr ve null neo ko co symbol nao
  Future<List<String>> getSymbolFromFavoriteList()async{
    var db=await database;
    var data=await db.query("FavoriteList");
    if(data.isEmpty){
      return null;
    }else{
      List<String> returnData=[];
      for(var f in data){
        returnData.add(f["symbol"]);
      }
      return returnData;
    }
  }
  //End DbProvider Class
}


