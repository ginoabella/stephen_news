import 'package:rxdart/rxdart.dart';

import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  //StreamControllers
  final _topIdsController = PublishSubject<List<int>>();
  final _itemsOutputController = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcherController = PublishSubject<int>();

  StoriesBloc() {
    _itemsFetcherController.stream
        .transform(_itemsTransformer())
        .pipe(_itemsOutputController);
  }

  //Getters to Stream
  Stream<List<int>> get topIds => _topIdsController.stream;
  Stream<Map<int, Future<ItemModel>>> get items =>
      _itemsOutputController.stream;

  //Getters to sink
  Function(int) get fetchItem => _itemsFetcherController.sink.add;

  Future<void> fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIdsController.sink.add(ids);
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, _) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIdsController.close();
    _itemsOutputController.close();
    _itemsFetcherController.close();
  }
}
