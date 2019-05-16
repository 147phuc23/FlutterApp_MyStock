import 'package:MyStock/resource/bloc/bloc.dart';
import 'package:MyStock/resource/route/sign_up.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthBloc authBloc = AuthBloc();
  final _userTextController = new TextEditingController();
  final _passTextController = new TextEditingController();

  void _onSubmit() async{
    if (await authBloc.isValidInfoSignIn(
        _userTextController.text, _passTextController.text))
      Navigator.pushReplacementNamed(context, '/home');
    isLoggedIn = true;
  }

  void _onSubmitAsGuest() {
    Navigator.pushReplacementNamed(context, '/home');
    isLoggedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  padding: EdgeInsets.all(20),
                  child: FlutterLogo(
                      // /size: 70,
                      ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "HELLO\nWELCOME BACK",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    bottom: 30,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15.0,
                            offset: Offset(0, 15)),
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15.0,
                          offset: Offset(0, -10),
                        )
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          right: 10,
                          top: 10,
                        ),
                        width: double.infinity - 10,
                        child: StreamBuilder(
                          stream: authBloc.userStream,
                          builder: (contex, snapshot) => TextField(
                                controller: _userTextController,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  labelText: "Username",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                            right: 10,
                            top: 10,
                          ),
                          width: double.infinity - 10,
                          child: StreamBuilder(
                            stream: authBloc.passStream,
                            builder: (context, snapshot) => TextField(
                                  controller: _passTextController,
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    errorText: snapshot.hasError
                                        ? snapshot.error
                                        : null,
                                    hintText: "Enter Password",
                                    labelText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(fontSize: 20),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _onSubmit,
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: _onSubmitAsGuest,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Text('Login as guest',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.blue,
                              )),
                        ),
                      ),
                      FlatButton(
                        onPressed: _onSignUp,
                        child: Container(
                            child: Text('Sign Up',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.blue,
                                ))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    authBloc.dispose();
  }

  void _onSignUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }
}
