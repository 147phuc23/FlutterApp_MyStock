import 'dart:async';
import 'package:newproject/resource/database/database.dart';
import 'package:flutter/material.dart';

class AuthBloc {
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;

  bool isValidInfo(String usr, String pwd){
    if (!Validation.isValidUserName(usr)) {
      _userController.sink.addError("Tên đăng nhập không hợp lệ!");
      return false;
    }
    if (!Validation.isValidPassword(pwd)) {
      _passController.sink.addError("Mật khẩu không hợp lệ!");
      return false;
    }
    _userController.sink.add("ok");
    _passController.sink.add("ok");
    return true;
  }


  void dispose() {
    _userController.close();
    _passController.close();
  }
}

class SearchBloc {
  StreamController _searchStreamController = StreamController();
  Stream get searchStream => _searchStreamController.stream;

  List<Map<String,dynamic>> listData=[];

  void updateSearch(String query)async{
    if(query==null) return;
    listData=await DbProvider.db.searchSymbol(query);
    _searchStreamController.sink.add(listData);
  }

  void dispose(){
    _searchStreamController.close();
  }
}

class Validation {
  static bool isValidUserName(String usrname) =>true;// usrname.contains('@') && usrname.length > 6;
  static bool isValidPassword(String pwd) =>true;// pwd.length > 6;
}


