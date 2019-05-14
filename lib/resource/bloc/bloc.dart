import 'dart:async';
import './login_info.dart';
import 'package:newproject/resource/database/database.dart';
import '../../demodata.dart';

class AuthBloc {
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;

  bool isValidInfo(String usr, String pwd) {
    return true;
    if (!AccountValidation.isValidUsername(usr)) {
      _userController.sink.addError("Tên đăng nhập không hợp lệ!");
      return false;
    }
    if (!AccountValidation.isValidPassword(pwd)) {
      _passController.sink.addError("Mật khẩu không hợp lệ!");
      return false;
    }
    accountList.forEach((f) {
      if (f.username == usr) if (f.password == pwd) return true;
    });
    return false; 
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
  static bool isValidUsername(String usrname) => usrname.length > 6;
  static bool isValidPassword(String pwd) => pwd.length > 6;
}
