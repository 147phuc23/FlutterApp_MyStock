import 'dart:async';

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



class Validation {
  static bool isValidUserName(String usrname) =>true;// usrname.contains('@') && usrname.length > 6;
  static bool isValidPassword(String pwd) =>true;// pwd.length > 6;
}

