
import 'package:flutter/material.dart';

class Account {
  String username;
  String password;
  Account(@required this.username ,@required this.password );
  Map favoriteList = null;
  String name;
}

List<Account> accountList = [
  Account("a","a"),
];