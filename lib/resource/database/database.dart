//Import library


import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

//Library written
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
    _database = await _initDB();
    await _initializeDatabase();
    var checkDb = await _database.query("Symbol",
        where: "symbol=?", whereArgs: ["alreadyBeenInitialize"]);
    if (checkDb.isEmpty)
      _database.insert("Symbol", {"symbol": "alreadyBeenInitialize"});
    return _database;
  }

  //Ham goi khoi tao cho database
  _initializeDatabase() async {
    await _initializeAllSymbol();
  }

  //Ham khoi tao cho getter
  _initDB() async {
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
      await db.execute("CREATE TABLE IF NOT EXISTS Symbol ("
          "symbol TEXT,"
          "name TEXT,"
          "date TEXT,"
          "isEnabled TEXT,"
          "type TEXT,"
          "iexId TEXT"
          ")");
      await db.execute("CREATE TABLE IF NOT EXISTS  FavoriteList(symbol TEXT)");
    });
  }

  //Ham khoi tao cho table Symbol
  _initializeAllSymbol() async {
    final db = await database;
    List<Map<String, dynamic>> checkDb = await db.query("Symbol",
        where: "symbol=?", whereArgs: ["alreadyBeenInitialize"]);
    if (checkDb.isNotEmpty) {
      print("Symbol database already been initialized");
      return null;
    }

    print("Initialize Symbols");
    String urlJson = "https://api.iextrading.com/1.0/ref-data/symbols";
    try {
      http.Response jsonResponse = await http.get(urlJson);
      List<DbSymbol> listSymbols = dbSymbolFromJson(jsonResponse.body);
      for (var f in listSymbols) {
        if (f != null) {
          var res = await db.insert("Symbol", f.toMap());
        }
      }
    } catch (e) {
      throw "Cannot get data.";
    }
  }

  //Tu day tro di la cac ham tra data ve


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
  Future<List<Map<String, dynamic>>> getAllSymbol() async {
    final db = await database;
    var res = await db.query("Symbol");
    return res.isEmpty ? null : res;
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
  Future<List<Map<String, dynamic>>> searchSymbol(String symbol) async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT * FROM Symbol WHERE symbol LIKE '$symbol%'");
    return res.isNotEmpty ? res : null;
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
  Future<List<Map<String, dynamic>>> getChartInfo_1m(String symbol) async {
    var db = await database;
    await db
        .execute("CREATE TABLE IF NOT EXISTS ${symbol.toUpperCase()}_chart_1m ("
            "open NUMBER,"
            "high NUMBER,"
            "low NUMBER,"
            "close NUMBER,"
            "volumeto NUMBER,"
            "label TEXT"
            ")");
    List<Map<String, dynamic>> checkSymbol =
        await db.query("Symbol", where: "symbol=?", whereArgs: [symbol]);
    print(checkSymbol.first);
    if (checkSymbol.isEmpty) {
      return null;
    } else {
      if (checkSymbol.first["isEnabled"] == "0") {
        print("Symbol is not supported");
        return null;
      }
    }
    var checkDate = await db.query("${symbol.toUpperCase()}_chart_1m",
        where: "label =?", whereArgs: ["haveData"]);
    String urlJson = "https://api.iextrading.com/1.0/stock/${symbol}/chart/1m";
    try {
      http.Response response = await http.get(urlJson);
      print("Data downloaded");
      await db.delete("${symbol.toUpperCase()}_chart_1m");
      List<DbChart1M> chart = dbChart1MFromJson(response.body);
      chart.removeWhere((item) {
        if (item.low == -1 ||
            item.high == -1 ||
            item.volume == 0 ||
            item.open == null ||
            item.close == null)
          return true;
        else
          return false;
      });
      List<Map<String, dynamic>> chartMap = [];
      for (int i = 0; i < chart.length; i++) {
        if (chart[i] != null) {
          chartMap.add(chart[i].toMapRequired());
          print(chartMap[i]);
          await db.insert(
              "${symbol.toUpperCase()}_chart_1m", chart[i].toMapRequired());
        }
      }
      await db
          .insert("${symbol.toUpperCase()}_chart_1m", {"label": "haveData"});
      return chartMap.isNotEmpty ? chartMap : [];
    } catch (e) {
      print("Catch error");
      if (checkDate.isEmpty) {
        return null;
      } else {
        print("Have offline data");
        List<Map<String, dynamic>> chartData =
            await db.query("${symbol.toUpperCase()}_chart_1m");
        print("Get database complete");
        for (var f in chartData) {
          print(f);
        }
        if (chartData.isNotEmpty)
          print("NotEmpty");
        else
          print("isEmpty");
        List<Map<String, dynamic>> chartDataInRequired = [];
        for (var f in chartData) {
          print(f);
          chartDataInRequired.add({
            "high": f["high"],
            "low": f["low"],
            "volumeto": f["volumeto"],
            "open": f["open"],
            "close": f["close"],
          });
        }
        chartDataInRequired.removeLast();
        print("Prepared to return data");
        return chartDataInRequired;
      }
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
  Future<List<Map<String, dynamic>>> getChartInfo_1d(String symbol) async {
    var db = await database;
    await db
        .execute("CREATE TABLE IF NOT EXISTS ${symbol.toUpperCase()}_chart_1d ("
            "label TEXT,"
            "open NUMBER,"
            "high NUMBER,"
            "low NUMBER,"
            "close NUMBER,"
            "volumeto NUMBER"
            ")");
    List<Map<String, dynamic>> checkSymbol =
        await db.query("Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      print("Not have symbol");
      return null;
    } else {
      if (checkSymbol.first["isEnabled"] == "0") {
        print(checkSymbol.first["isEnabled"]);
        print("Symbol is not supported");
        return null;
      }
    }
    var checkDate = await db.query("${symbol.toUpperCase()}_chart_1d",
        where: "label =?", whereArgs: ["haveData"]);
    String urlJson =
        "https://api.iextrading.com/1.0/stock/${symbol}/chart/1d?chartInterval=10";
    try {
      http.Response response = await http.get(urlJson);
      print("Download data completed");
      await db.delete("${symbol.toUpperCase()}_chart_1d");
      print("Delete table complete");
      List<DbChart1D> chart = dbChart1DFromJson(response.body);
      chart.removeWhere((item) {
        if (item.low == -1 ||
            item.high == -1 ||
            item.volume == 0 ||
            item.open == null ||
            item.close == null)
          return true;
        else
          return false;
      });
      print("Transform comple");
      print(response.body);
      List<Map<String, dynamic>> chartMap = [];
      for (int i = 0; i < chart.length; i++) {
        if (chart[i] != null) {
          chartMap.add(chart[i].toMapRequired());
          print(chart[i].toMapRequired());
          await db.insert(
              "${symbol.toUpperCase()}_chart_1d", chart[i].toMapRequired());
        }
      }
      await db
          .insert("${symbol.toUpperCase()}_chart_1d", {"label": "haveData"});
      return chartMap.isNotEmpty ? chartMap : [];
    } catch (e) {
      print("Catch error");
      if (checkDate.isEmpty) {
        return null;
      } else {
        print("Have offline data");
        List<Map<String, dynamic>> chartData =
            await db.query("${symbol.toUpperCase()}_chart_1d");
        print("Get database complete");
        for (var f in chartData) {
          print(f);
        }
        if (chartData.isNotEmpty)
          print("NotEmpty");
        else
          print("isEmpty");
        List<Map<String, dynamic>> chartDataInRequired = [];
        for (var f in chartData) {
          print(f);
          chartDataInRequired.add({
            "high": f["high"],
            "low": f["low"],
            "volumeto": f["volumeto"],
            "open": f["open"],
            "close": f["close"],
          });
        }
        chartDataInRequired.removeLast();
        print("Prepared to return data");
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
  Future<List<Map<String, dynamic>>> getChartInfo_3d(String symbol) async {
    print("Begin get chart 3 d");
    var db = await database;
    await db
        .execute("CREATE TABLE IF NOT EXISTS ${symbol.toUpperCase()}_chart_3d ("
            "label TEXT,"
            "open NUMBER,"
            "high NUMBER,"
            "low NUMBER,"
            "close NUMBER,"
            "volumeto NUMBER"
            ")");
    var checkDate = await db.query("${symbol.toUpperCase()}_chart_3d",
        where: "label =?", whereArgs: ["haveData"]);
    List<Map<String, dynamic>> checkSymbol =
        await db.query("Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      print("Not have symbol");
      return null;
    } else {
      if (checkSymbol.first["isEnabled"] == "0") {
        print(checkSymbol.first["isEnabled"]);
        print("Symbol is not supported");
        return null;
      }
    }
    try {
      //Get chart data for 3d latest
      DateTime time = new DateTime.now();
      time = time.subtract(new Duration(days: 2));
      var formatter = new DateFormat('yyyyMMdd');
      String dateFormatter = formatter.format(time);
      String urlJson =
          "https://api.iextrading.com/1.0/stock/$symbol/chart/date/$dateFormatter?chartInterval=10";
      http.Response response = await http.get(urlJson);
      List<DbChart1D> chart = dbChart1DFromJson(response.body);
      chart.removeWhere((item) {
        if (item.high == -1.0 ||
            item.low == -1.0 ||
            item.volume == 0 ||
            item.open == null ||
            item.close == null)
          return true;
        else
          return false;
      });
      List<Map<String, dynamic>> chartMap = new List<Map<String, dynamic>>();
      for (int i = 0; i < chart.length; i++) {
        if (chart[i] != null) chartMap.add(chart[i].toMapRequired());
      }
      print("Done 2 days ago");
      time = DateTime.now();
      time = time.subtract(new Duration(days: 1));
      dateFormatter = formatter.format(time);
      urlJson =
          "https://api.iextrading.com/1.0/stock/$symbol/chart/date/$dateFormatter?chartInterval=10";
      response = await http.get(urlJson);
      chart = dbChart1DFromJson(response.body);
      chart.removeWhere((item) {
        if (item.high == -1.0 ||
            item.low == -1.0 ||
            item.volume == 0 ||
            item.open == null ||
            item.close == null)
          return true;
        else
          return false;
      });
      for (int i = 0; i < chart.length; i++) {
        if (chart[i] != null) chartMap.add(chart[i].toMapRequired());
      }
      print("Done 1 days ago");
      urlJson =
          "https://api.iextrading.com/1.0/stock/$symbol/chart/1d?chartInterval=10";
      response = await http.get(urlJson);
      chart = dbChart1DFromJson(response.body);
      chart.removeWhere((item) {
        if (item.high == -1.0 ||
            item.low == -1.0 ||
            item.volume == 0 ||
            item.open == null ||
            item.close == null)
          return true;
        else
          return false;
      });
      for (int i = 0; i < chart.length; i++) {
        if (chart[i] != null) chartMap.add(chart[i].toMapRequired());
      }
      print("Done today");
      //Add data to database
      List<Map<String, dynamic>> returnChart = [];
      await db.delete("${symbol.toUpperCase()}_chart_3d");
      for (int i = 0; i < chartMap.length; i++) {
        if (chartMap[i] != null) {
          returnChart.add(chartMap[i]);
          await db.insert("${symbol.toUpperCase()}_chart_3d", chartMap[i]);
        }
      }
      await db
          .insert("${symbol.toUpperCase()}_chart_3d", {"label": "haveData"});
      return chartMap.isNotEmpty ? chartMap : [];
    } catch (e) {
      print("Catch error");
      if (checkDate.isEmpty) {
        return null;
      } else {
        print("Have offline data");
        List<Map<String, dynamic>> chartData =
            await db.query("${symbol.toUpperCase()}_chart_3c");
        print("Get database complete");
        for (var f in chartData) {
          print(f);
        }
        if (chartData.isNotEmpty)
          print("NotEmpty");
        else
          print("isEmpty");
        List<Map<String, dynamic>> chartDataInRequired = [];
        for (var f in chartData) {
          print(f);
          chartDataInRequired.add({
            "high": f["high"],
            "low": f["low"],
            "volumeto": f["volumeto"],
            "open": f["open"],
            "close": f["close"],
          });
        }
        chartDataInRequired.removeLast();
        print("Prepared to return data");
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
  Future<Map<String, dynamic>> getRealTimeInfo(String symbol) async {
    var db = await database;
    await db.execute("CREATE TABLE IF NOT EXISTS RealTimeInfo("
        "symbol TEXT,"
        "companyName TEXT,"
        "sector TEXT,"
        "primaryExchange TEXT,"
        "open NUMBER,"
        "close NUMBER,"
        "high NUMBER,"
        "low NUMBER,"
        "latestPrice NUMBER,"
        "latestSource TEXT,"
        "previousClose NUMBER,"
        "change NUMBER,"
        "changePercent NUMBER,"
        "marketCap NUMBER,"
        "peRatio NUMBER"
        ")");
    var checkDate = await db.query("RealTimeInfo",
        where: "symbol=?", whereArgs: [symbol.toUpperCase()]);
    List<Map<String, dynamic>> checkSymbol =
        await db.query("Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSymbol.isEmpty) {
      return null;
    } else {
      if (checkSymbol.first["isEnabled"].toString().toLowerCase() == "0") {
        return null;
      }
    }
    String urlJson = "https://api.iextrading.com/1.0/stock/$symbol/quote";
    try {
      http.Response response = await http.get(urlJson);
      print("getRealTimeInfo::Get data complete");
      DbQuote quote = dbQuoteFromJson(response.body);
      print("getRealTimeInfo::Trans Data complete");
      if (checkDate.isNotEmpty)
        await db.update("RealTimeInfo", quote.toMapRequired(),
            where: "symbol=?", whereArgs: [symbol.toUpperCase()]);
      else
        await db.insert("RealTimeInfo", quote.toMapRequired());
      print("getRealTimeInfo::Add data to database complete");
      return quote.toMapRequired();
    } catch (e) {
      if (checkDate.isEmpty) {
        print("getRealTimeInfo::Not have data available");
        return null;
      }
      var data = await db
          .query("RealTimeInfo", where: "symbol=?", whereArgs: [symbol]);
      return data.first;
    }
  }


  Future<List<Map<String,dynamic>>> getListRealInfo(List<String> symbol)async{
    var db = await database;
    await db.execute("CREATE TABLE IF NOT EXISTS RealTimeInfo("
        "symbol TEXT,"
        "companyName TEXT,"
        "sector TEXT,"
        "primaryExchange TEXT,"
        "open NUMBER,"
        "close NUMBER,"
        "high NUMBER,"
        "low NUMBER,"
        "latestPrice NUMBER,"
        "latestSource TEXT,"
        "previousClose NUMBER,"
        "change NUMBER,"
        "changePercent NUMBER,"
        "marketCap NUMBER,"
        "peRatio NUMBER"
        ")");
    List<Map<String,dynamic>> checkDate=[];
    for(var f in symbol){
      var check = await db.query("RealTimeInfo",
          where: "symbol=?", whereArgs: [f.toUpperCase()]);
      if(check.isNotEmpty)
        checkDate.add(check.first);
    }
    List<Map<String,dynamic>> listReturnedData=[];
    String urlJson = "https://api.iextrading.com/1.0/stock/market/batch?symbols=${symbol.join(',')}&types=quote";
    print(urlJson);
    try {
      http.Response response = await http.get(urlJson);
      print("Get data complete");
      var decodeData=jsonDecode(response.body);
      List<Map<String,dynamic>> transData=[];
      List<DbQuote> listDataCompany=[];
      for(var f in symbol){
        transData.add(decodeData[f]['quote']);
      }
      if(transData.isNotEmpty) print("getListRealTimeInfo::Is not empty");
      for(var f in transData){
        DbQuote quote = DbQuote.fromMap(f);
        print("getListRealTimeInfo::${quote.toMapRequired()}");
        listDataCompany.add(quote);
      }
      print("getListRealTimeInfo::Trans Data complete");
      for(var f in listDataCompany){
        if (checkDate.where((item)=>item['symbol']==f.symbol)!=null)
          await db.update("RealTimeInfo", f.toMapRequired(),
              where: "symbol=?", whereArgs: [f.symbol.toUpperCase()]);
        else
          await db.insert("RealTimeInfo", f.toMapRequired());
        print("Add data to database complete");
        listReturnedData.add(f.toMapRequired());
      }
      return listReturnedData;
    } catch (e) {
      print(e);
      if (checkDate.isEmpty) {
        print("Not have data available");
        return [];
      }
      return checkDate;
    }
  }
  //Ham tra ve top 10 symbols hoat dong manh nhat
  //Map tra ve:{{
  //    "symbol": symbol,
  //    "companyName": companyName,
  //    "primaryExchange": primaryExchange,
  //    "sector": sector,
  //    "open": open,
  //    "close": close,
  //    "high": high,
  //    "low": low,
  //    "latestPrice": latestPrice,
  //    "previousClose": previousClose,
  //    "change": change,
  //    "changePercent": changePercent,
  //    "marketCap": marketCap,
  //    "peRatio": peRatio == null ? null : peRatio,
  //  };
  Future<List<Map<String, dynamic>>> getTopSymbols() async {
    var db = await database;
    await db.execute("CREATE TABLE IF NOT EXISTS Top_Symbols ("
        "symbol TEXT,"
        "companyName TEXT,"
        "sector TEXT,"
        "primaryExchange TEXT,"
        "open NUMBER,"
        "close NUMBER,"
        "high NUMBER,"
        "low NUMBER,"
        "latestPrice NUMBER,"
        "previousClose NUMBER,"
        "change NUMBER,"
        "changePercent NUMBER,"
        "marketCap NUMBER,"
        "latestSource TEXT,"
        "peRatio NUMBER"
        ")");
    var checkDate = await db
        .query("Top_Symbols", where: "symbol =?", whereArgs: ["haveData"]);
    String urlJson = "https://api.iextrading.com/1.0/stock/market/list/infocus";
    try {
      http.Response response = await http.get(urlJson);
      print("Get Top symbols worked");
      List<DbTopSymbols> topSymbol = dbTopSymbolsFromJson(response.body);
      for (int i = 0; i < topSymbol.length; i++) {}
      List<Map<String, dynamic>> returnMap = [];
      await db.delete("Top_Symbols");
      await db.insert("Top_Symbols", {"symbol": "haveData"});
      for (var f in topSymbol) {
        if (f != null) {
          await db.insert("Top_Symbols", f.toMap());
          returnMap.add(f.toMap());
        }
      }
      return returnMap;
    } catch (e) {
      if (checkDate.isEmpty) {
        return null;
      } else {
        print("Get top symbol workded");
        var data =
            await db.query("Top_Symbols", where: "symbol NOT LIKE 'haveData'");
        return data;
      }
    }
  }

  //Ham dung de them vao favorite list
  //Ham se tra ve true neu them vao thanh cong hoac symbol da co trong list
  //Tra ve false neu symbol khong duoc ho tro hoac khong co trong list symbol lay tu API
  Future<bool> addToFavoriteList(String symbol) async {
    var db = await database;
    var checkSupported =
        await db.query("Symbol", where: "symbol=?", whereArgs: [symbol]);
    if (checkSupported.isEmpty) {
      return false;
    } else {
      if (checkSupported.first["isEnabled"] == "0") {
        return false;
      }
    }
    var checkDb =
        await db.query("FavoriteList", where: "symbol=?", whereArgs: [symbol]);
    if (checkDb.isNotEmpty) {
      return true;
    } else {
      await db.insert("FavoriteList", {"symbol": symbol});
      return true;
    }
  }

  //Ham dung de xoa 1 symbol ra khoi FavoriteList
  //Ham se tra ve true neu xoa thanh cong
  Future<bool> deleteFromFavoriteList(String symbol) async {
    var db = await database;
    await db.delete("FavoriteList", where: "symbol=?", whereArgs: [symbol]);
    return true;
  }

  //Ham dung de lay tat ca cac symbnol dang co trong Favorite List
  //Ham se tra ve List<String> cac symbol hoac tr ve null neo ko co symbol nao
  Future<List<String>> getSymbolFromFavoriteList() async {
    var db = await database;
    var data = await db.query("FavoriteList");
    if (data.isEmpty) {
      return null;
    } else {
      List<String> returnData = [];
      for (var f in data) {
        returnData.add(f["symbol"]);
      }
      return returnData;
    }
  }
  //End DbProvider Class
}
