import 'package:flutter/material.dart';
import 'package:newproject/resource/bloc/bloc.dart';

class CodeSearch extends SearchDelegate<Map> {
  SearchBloc bloc;
  CodeSearch(this.bloc);
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

    bloc.updateSearch(query==null?"":query);
    return StreamBuilder(
      stream: bloc.searchStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var results = snapshot.data;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];
              return ListTile(
                title: Text(result['symbol']),
              );
            },
          );
        }else if(!snapshot.hasData){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
            ],
          );
        }else if(snapshot.data.length==0){
          return Column(
            children: <Widget>[
              Text(
                "No Results Found.",
              ),
            ],
          );
        }
        ;
      },
    );
  }
}
