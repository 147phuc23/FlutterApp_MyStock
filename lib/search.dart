import 'package:flutter/material.dart';
import 'package:newproject/demodata.dart';
import 'package:newproject/resource/bloc/bloc.dart';

class CodeSearch extends SearchDelegate<Map> {
  Stream codeStream;
  SearchBloc bloc = new SearchBloc();
  CodeSearch({this.codeStream});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    bloc.search(query);
    return StreamBuilder(
      stream: bloc.searchStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
          return ListView(
            // children: snapshot.data
            //     .map((f) => ListTile(
            //           title: Text("$f["symbol"]$"),
            //         ))
            //     .toList()
            children: <Widget>[
              Text("${snapshot.data[0]}"),
              Text("${snapshot.data[1]}"),
              Text("${snapshot.data[2]}")
            ],
          );
        else if (snapshot.hasError)
          return Center(
            child: Text("error"),
          );
        else
          return LinearProgressIndicator();
      },
    );
    // );
    // final result = favoriteData.where((p) {
    //   return p["symbol"].startsWith(query.toUpperCase());
    // }).toList();
    // return ListView(
    //     children: result
    //         .map((f) => ListTile(title: Text("${f["symbol"]}")))
    //         .toList());
  }
}
