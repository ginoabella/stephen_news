import 'package:flutter/material.dart';

import 'package:news/src/screens/news_list.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/screens/news_detail.dart';
import 'package:news/src/blocs/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News',
          onGenerateRoute: (settings) => routes(settings),
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);
          storiesBloc.fetchTopIds();
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name.replaceFirst('/', ''));
          commentsBloc.fetchItemWithComments(itemId);
          return NewsDetail(itemId: itemId);
        },
      );
    }
  }
}
