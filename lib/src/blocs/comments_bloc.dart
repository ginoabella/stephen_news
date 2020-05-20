import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/repository.dart';

class CommentsBloc {
  final _repository = Repository();

  CommentsBloc() {
    _commentsFetcherController.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutputController);
  }

  //StreamControllers
  final _commentsFetcherController = PublishSubject<int>();
  final _commentsOutputController =
      BehaviorSubject<Map<int, Future<ItemModel>>>();

  //Getters to Stream
  Stream<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutputController.stream;

  //Getters to sink
  Function(int) get fetchItemWithComments =>
      _commentsFetcherController.sink.add;

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, index) {
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item) {
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        });
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _commentsFetcherController.close();
    _commentsOutputController.close();
  }
}
