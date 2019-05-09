// To parse this JSON data, do
//
//     final dbCompanyInfor = dbCompanyInforFromJson(jsonString);

import 'dart:convert';

import './database_interface_data_tranform.dart';

DbCompanyInfo dbCompanyInforFromJson(String str) =>DbCompanyInfo.fromMap(json.decode(str));

class DbCompanyInfo implements DataTranform{
  String symbol;
  String companyName;
  String exchange;
  String industry;
  String website;
  String description;
  String ceo;
  String issueType;
  String sector;
  List<String> tags;

  DbCompanyInfo({
    this.symbol,
    this.companyName,
    this.exchange,
    this.industry,
    this.website,
    this.description,
    this.ceo,
    this.issueType,
    this.sector,
    this.tags,
  });

  factory DbCompanyInfo.fromMap(Map<String, dynamic> data) =>
      new DbCompanyInfo(
        symbol: data["symbol"],
        companyName: data["companyName"],
        exchange: data["exchange"],
        industry: data["industry"],
        website: data["website"],
        description: data["description"],
        ceo: data["CEO"],
        issueType: data["issueType"],
        sector: data["sector"],
        tags: new List<String>.from(data["tags"].map((x) => x)),
      );
  factory DbCompanyInfo.fromMapDatabase(Map<String, dynamic> data) {
    List<String> temp;
    if(data['tag1']!='') temp.add(data['tag1']);
    if(data['tag2']!='') temp.add(data['tag2']);
    if(data['tag3']!='') temp.add(data['tag3']);
    return new DbCompanyInfo(
      symbol: data["symbol"],
      companyName: data["companyName"],
      exchange: data["exchange"],
      industry: data["industry"],
      website: data["website"],
      description: data["description"],
      ceo: data["CEO"],
      issueType: data["issueType"],
      sector: data["sector"],
      tags: temp
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "symbol": symbol,
      "companyName": companyName,
      "exchange": exchange,
      "industry": industry,
      "website": website,
      "description": description,
      "CEO": ceo,
      "issueType": issueType,
      "sector": sector,
      "tag": new List<dynamic>.from(tags.map((x) => x)),
    };
  }
  Map<String,dynamic> toMapDatabase(){
    return{
      "symbol": symbol,
      "companyName": companyName,
      "exchange": exchange,
      "industry": industry,
      "website": website,
      "description": description,
      "CEO": ceo,
      "issueType": issueType,
      "sector": sector,
      "tag1": tags.length>1?tags[0]:null,
      "tag2" : tags.length>2?tags[1]:null,
      "tag3": tags.length>3?tags[2]:null
    };
  }
}
