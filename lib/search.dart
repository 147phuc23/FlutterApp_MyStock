import 'package:flutter/material.dart';

class CodeSearch extends SearchDelegate<Map> {
  Stream codeStream;
  CodeSearch(this.codeStream);
  @override

  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StreamBuilder(
      stream: codeStream,
      builder: (context, snapshot) {

        return ListView(children: <Widget>[Text('asd'),Text('asd'),Text('asd')],);
      },
    );
  }
}
