// To parse this JSON data, do
//
//     final dbCompanyInfor = dbCompanyInforFromJson(jsonString);

import 'dart:convert';

DbCompanyInfor dbCompanyInforFromJson(String str) =>DbCompanyInfor.fromJson(json.decode(str));


String dbCompanyInforToJson(DbCompanyInfor data)=> json.encode(data.toJson());

class DbCompanyInfor {
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

  DbCompanyInfor({
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

  factory DbCompanyInfor.fromJson(Map<String, dynamic> json) =>
      new DbCompanyInfor(
        symbol: json["symbol"],
        companyName: json["companyName"],
        exchange: json["exchange"],
        industry: json["industry"],
        website: json["website"],
        description: json["description"],
        ceo: json["CEO"],
        issueType: json["issueType"],
        sector: json["sector"],
        tags: new List<String>.from(json["tags"].map((x) => x)),
      );
  factory DbCompanyInfor.fromMap(Map<String, dynamic> data) =>
      new DbCompanyInfor(
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
  factory DbCompanyInfor.fromMapDatabase(Map<String, dynamic> data) {
    List<String> temp;
    if(data['tag1']!='') temp.add(data['tag1']);
    if(data['tag2']!='') temp.add(data['tag2']);
    if(data['tag3']!='') temp.add(data['tag3']);
    return new DbCompanyInfor(
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

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "companyName": companyName,
        "exchange": exchange,
        "industry": industry,
        "website": website,
        "description": description,
        "CEO": ceo,
        "issueType": issueType,
        "sector": sector,
        "tags": new List<dynamic>.from(tags.map((x) => x)),
      };

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
