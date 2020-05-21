import 'package:flutter/material.dart';

import 'package:news/src/models/item_model.dart';
import 'package:news/src/widget/loading_container.dart';

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
          return LoadingContainer();
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
              title: _buildText(snapshot.data),
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

  Widget _buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27;', '\'')
        .replaceAll('&#x2F;', '\/')
        .replaceAll('&quot;', '\"')
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(text);
  }
}
