import 'dart:async';
import 'package:MyStock/main.dart';

import './login_info.dart';
import 'package:MyStock/resource/database/database.dart';
import '../../demodata.dart';

class AuthBloc {
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;

  Future<bool> isValidInfoSignIn(String usr, String pwd) async{
    if (!AccountValidation.isValidUsername(usr)) {
      _userController.sink.addError("Tên đăng nhập không hợp lệ!");
      return false;
    }
    if (!AccountValidation.isValidPassword(pwd)) {
      _passController.sink.addError("Mật khẩu không hợp lệ!");
      return false;
    }
    // bool x = false;
    // accountList.forEach((f) {
    //   if (f.username == usr) if (f.password == pwd) {
    //     x = true;
    //   }
    // });
    // return x;
    if (await isValidAccount(usr, pwd)) logedInAccount = new Account(usr, pwd);
    return await isValidAccount(usr, pwd);
    ;
  }

  isValidAccount(usr, pwd) async {
    bool valid = await DbProvider.db.checkAccountInfo(usr, pwd);
    return valid;
  }

  Future<bool> isValidInfoSignUp(String usr, String pwd) async{
    if (!AccountValidation.isValidUsername(usr)) {
      _userController.sink.addError("Tên đăng nhập không hợp lệ!");
      return false;
    }
    if (!AccountValidation.isValidPassword(pwd)) {
      _passController.sink.addError("Mật khẩu không hợp lệ!");
      return false;
    }
    // bool x = true;
    // accountList.forEach((f) {
    //   if (f.username == usr) {
    //     x = false;
    //     logedInAccount = f;
    //     _userController.sink.addError("Tên đăng nhập đã tồn tại!");
    //   }
    // // });
    // return x;
    if (await isValidInfoSignUpAccount(usr, pwd))
      return true;
    else {
      _userController.sink.addError("Tên đăng nhập đã tồn tại!");
      return false;
    }
    ;
  }

  isValidInfoSignUpAccount(usr, pwd) async {
    bool valid = await DbProvider.db.writeAccountInfo(usr, pwd);
    return valid;
  }

  void dispose() {
    _userController.close();
    _passController.close();
  }
}

class SearchBloc {
  StreamController _searchStreamController = StreamController.broadcast();
  Stream get searchStream => _searchStreamController.stream;

  List<Map<String, dynamic>> listData = [];

  void updateSearch(String query) async {
    if (query == null) return;
    listData = await DbProvider.db.searchSymbol(query);
    _searchStreamController.sink.add(listData);
  }

  void dispose() {
    _searchStreamController.close();
  }
}

class AccountValidation {
  static bool isValidUsername(String usrname) => usrname.length >= 6;
  static bool isValidPassword(String pwd) => pwd.length >= 6;
}
