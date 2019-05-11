
import 'package:flutter/material.dart';

class Account {
  String username;
  String password;
  Account(@required this.username ,@required this.password );
  Map favoriteList = null;
}

List<Account> accountList = [
  Account("admin","password"),
];