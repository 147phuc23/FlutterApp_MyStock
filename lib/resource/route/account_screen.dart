import 'package:flutter/material.dart';
import 'package:MyStock/main.dart';
import 'package:MyStock/resource/route/login_screen.dart';

class ScreenAccount extends StatefulWidget {
  @override
  _ScreenAccountState createState() => _ScreenAccountState();
}

class _ScreenAccountState extends State<ScreenAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createAppBar('Account setting'),
        body: Column(
          children: <Widget>[
            Card(
                child: ListTile(
                    title: Row(
              children: <Widget>[
                Container(
                  width: 75,
                  height: 75,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                  child: FlatButton(
                    onPressed: () {},
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Đặng Hoàng Phúc",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Administator",
                            style: TextStyle(fontSize: 15),
                          )
                        ]),
                  ),
                )
              ],
            ))),
            Card(
              child: SizedBox(
                width: double.infinity,
                child: FlatButton(
                  onPressed: () {
                    logedInAccount = null; 
                    isLogedIn = false;  
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);                    
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Text(
                      'Log out',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
