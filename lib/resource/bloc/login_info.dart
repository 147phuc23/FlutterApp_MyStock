
import 'package:flutter/material.dart';

class Account {
  String username;
  String password;
  Account(@required this.username ,@required this.password, {this.favoriteList});
  List favoriteList;
  String name;
}

List<Account> accountList = [
  Account("aaaaaa","aaaaaa"),
];