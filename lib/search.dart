import 'package:MyStock/resource/bloc/bloc.dart';
import 'package:MyStock/resource/database/database.dart';
import 'package:MyStock/resource/route/detail_screen.dart';
import 'package:flutter/material.dart';

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

  fetchData(symbol) async {
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
                onTap: () async {
                  result = await fetchData(result["symbol"]);
                  if(result!=null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InforDetailsScreen(result)));
                  }else{
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NullInfo()));
                  }
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
