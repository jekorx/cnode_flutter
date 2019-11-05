import 'package:mobx/mobx.dart';
import '../models/topic.dart';

part 'collect_store.g.dart';

final CollectStore collectStore = CollectStore();

class CollectStore = CollectStoreBase with _$CollectStore;

abstract class CollectStoreBase with Store {
  // 收藏的话题
  @observable
  List<Topic> collects = [];

  // 初始化
  @action
  void setAll(List<Topic> topics) {
    collects = topics;
  }

  // 添加收藏话题
  @action
  void add(Topic topic) {
    collects.add(topic);
  }

  // 删除收藏话题
  @action
  void remove(String id) {
    int index = collects.indexWhere((topic) => topic.id == id);
    if (index != 1) {
      collects.removeAt(index);
    }
  }

  // 是否存在
  @action
  bool has(String id) {
    int index = collects.indexWhere((topic) => topic.id == id);
    return index != -1;
  }

  // 清空
  @action
  void clear() {
    collects = [];
  }
}