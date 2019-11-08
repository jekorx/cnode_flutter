import 'package:mobx/mobx.dart';
import '../models/topic.dart';

part 'collect_store.g.dart';

final CollectStore collectStore = CollectStore();

class CollectStore = CollectStoreBase with _$CollectStore;

abstract class CollectStoreBase with Store {
  // 收藏的话题
  @observable
  ObservableList<Topic> collects = ObservableList<Topic>();

  // 收藏话题id
  @computed
  List<String> get collectIds => this.collects.map((collect) => collect.id).toList();

  // 初始化
  @action
  void setAll(List<Topic> topics) {
    this.collects = ObservableList<Topic>.of(topics);
  }

  // 添加收藏话题
  @action
  void add(Topic topic) {
    this.collects.add(topic);
  }

  // 删除收藏话题
  @action
  void remove(String id) {
    int index = this.collects.indexWhere((topic) => topic.id == id);
    if (index != 1) {
      this.collects.removeAt(index);
    }
  }

  // 清空
  @action
  void clear() {
    this.collects.clear();
  }
}