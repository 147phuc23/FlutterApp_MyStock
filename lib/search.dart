import 'package:flutter/material.dart';
import 'package:newproject/resource/bloc/bloc.dart';
import 'package:newproject/resource/database/database.dart';
import 'package:newproject/resource/route/detail_screen.dart';
import 'package:path/path.dart';

class CodeSearch extends SearchDelegate<Map> {
  SearchBloc bloc;
  CodeSearch(this.bloc);
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

  Future fetchData(symbol) async {
    Map code = await DbProvider.db.getRealTimeInfo(symbol);
    return code;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    bloc.updateSearch(query == null ? "" : query);
    return StreamBuilder(
      stream: bloc.searchStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var results = snapshot.data;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FutureBuilder(
                                builder: (context, snapshot) {
                                  if (snapshot.hasData)
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InforDetailScreen(
                                                    snapshot.data)));                                  
                                },
                                future: fetchData(result['symbol']),
                              )));
                },
                child: ListTile(
                  title: Text(result['symbol']),
                ),
              );
            },
          );
        } else if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else if (snapshot.data.length == 0) {
          return Column(
            children: <Widget>[
              Text(
                "No Results Found.",
              ),
            ],
          );
        }
        
      },
    );
  }
}
