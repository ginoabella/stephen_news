import 'dart:async';

import 'package:news/src/resources/news_api_provider.dart';
import 'package:news/src/resources/news_db_provider.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/abstract.dart';

class Repository {
  List<Source> sources = [
    newsDbProvider,
    NewsApiProvider(),
  ];
  List<Cache> caches = [
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() async {
    List<int> topIds;

    for (var source in sources) {
      topIds = await source.fetchTopIds();
      if (topIds != null) {
        break;
      }
    }
    return topIds;
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        cache.addItem(item);
      }
    }

    return item;
  }

  Future<void> clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}
