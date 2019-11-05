import 'package:flutter/material.dart';
import '../components/topic_item.dart';
import '../models/topic.dart';

class PersonalTopics extends StatelessWidget {

  final List<List<dynamic>> tabList;
  final List<Topic> collects;
  final int tabIndex;

  PersonalTopics(this.tabList, this.tabIndex, { this.collects });

  @override
  Widget build(BuildContext context) {
    return ((collects != null && tabIndex == 2 && collects.length > 0) || tabList[tabIndex].length > 0) ? SliverFixedExtentList(
      itemExtent: 104,
      delegate: SliverChildBuilderDelegate(
        (BuildContext ctx, int index) {
          if (collects != null && tabIndex == 2) {
            return TopicItem(collects[index], index);
          } else {
            return TopicItem(Topic.fromJson(tabList[tabIndex][index] as Map<String, dynamic>), index);
          }
        },
        childCount: (collects != null && tabIndex == 2) ? collects.length : tabList[tabIndex].length,
      ),
    ) : SliverFixedExtentList(
      itemExtent: 60,
      delegate: SliverChildBuilderDelegate(
        (BuildContext ctx, int index) => Center(
          child: Text('没有相关信息', style: TextStyle(color: Colors.black45)),
        ),
        childCount: 1,
      ),
    );
  }
}