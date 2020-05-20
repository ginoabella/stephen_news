import 'package:flutter/material.dart';

import 'package:news/src/models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return Text('Still Loading Comment');
        }
        final commentList = snapshot.data.kids.map((kidId) {
          return Comment(
            itemId: kidId,
            itemMap: itemMap,
            depth: depth + 1,
          );
        }).toList();
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(snapshot.data.text),
              subtitle:
                  Text(snapshot.data.by.isEmpty ? 'Deleted' : snapshot.data.by),
              contentPadding:
                  EdgeInsets.only(left: 16 * depth.toDouble(), right: 16),
            ),
            Divider(height: 8),
            ...commentList,
          ],
        );
      },
    );
  }
}
