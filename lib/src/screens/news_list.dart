import 'package:flutter/material.dart';

import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/widget/news_list_tile.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    //bad this is temporary
    bloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: _buildList(bloc),
    );
  }

  Widget _buildList(StoriesBloc bloc) {
    return StreamBuilder(
        stream: bloc.topIds,
        builder: (context, AsyncSnapshot<List<int>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                bloc.fetchItem(snapshot.data[index]);
                return NewsListTile(itemId: snapshot.data[index]);
              });
        });
  }
}
