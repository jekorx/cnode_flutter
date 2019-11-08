import 'package:mobx/mobx.dart';

part 'user_store.g.dart';

final UserStore userStore = UserStore();

class UserStore = UserStoreBase with _$UserStore;

abstract class UserStoreBase with Store {
  // token
  @observable
  String token = '';
  // 用户名
  @observable
  String name = '';
  // 头像
  @observable
  String avatar = '';

  @action
  void setInfo(String token, String name, String avatar) {
    this.token = token;
    this.name = name;
    this.avatar = avatar;
  }

  @action
  void clear() {
    this.token = '';
    this.name = '';
    this.avatar = '';
  }
}