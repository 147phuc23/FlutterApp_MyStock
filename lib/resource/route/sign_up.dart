import 'package:MyStock/resource/bloc/bloc.dart';
import 'package:MyStock/resource/bloc/login_info.dart';
import 'package:MyStock/resource/database/database.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  TextEditingController _nameTextController = new TextEditingController();
  AuthBloc bloc = new AuthBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar("SIGN UP"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: StreamBuilder(
                  stream: bloc.userStream,
                  builder: (context, snapshot) => TextField(
                        controller: _usernameTextController,
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: "Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                  obscureText: true,
                  controller: _passwordTextController,
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _nameTextController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  onPressed: _onSubmit,
                  child: Text("Submit"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onSubmit() async{
    if (await bloc.isValidInfoSignUp(
        _usernameTextController.text, _passwordTextController.text)) {
      Account newAccount = new  Account(_usernameTextController.text,_passwordTextController.text);
      newAccount.name =  _nameTextController.text;
      Navigator.of(context).pushReplacementNamed('/home');
      logedInAccount = newAccount;
      isLoggedIn = true;
    }
  }
}
