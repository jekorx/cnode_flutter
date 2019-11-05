// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on UserStoreBase, Store {
  final _$tokenAtom = Atom(name: 'UserStoreBase.token');

  @override
  String get token {
    _$tokenAtom.context.enforceReadPolicy(_$tokenAtom);
    _$tokenAtom.reportObserved();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.context.conditionallyRunInAction(() {
      super.token = value;
      _$tokenAtom.reportChanged();
    }, _$tokenAtom, name: '${_$tokenAtom.name}_set');
  }

  final _$nameAtom = Atom(name: 'UserStoreBase.name');

  @override
  String get name {
    _$nameAtom.context.enforceReadPolicy(_$nameAtom);
    _$nameAtom.reportObserved();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.context.conditionallyRunInAction(() {
      super.name = value;
      _$nameAtom.reportChanged();
    }, _$nameAtom, name: '${_$nameAtom.name}_set');
  }

  final _$avatarAtom = Atom(name: 'UserStoreBase.avatar');

  @override
  String get avatar {
    _$avatarAtom.context.enforceReadPolicy(_$avatarAtom);
    _$avatarAtom.reportObserved();
    return super.avatar;
  }

  @override
  set avatar(String value) {
    _$avatarAtom.context.conditionallyRunInAction(() {
      super.avatar = value;
      _$avatarAtom.reportChanged();
    }, _$avatarAtom, name: '${_$avatarAtom.name}_set');
  }

  final _$UserStoreBaseActionController =
      ActionController(name: 'UserStoreBase');

  @override
  void setInfo(String token, String name, String avatar) {
    final _$actionInfo = _$UserStoreBaseActionController.startAction();
    try {
      return super.setInfo(token, name, avatar);
    } finally {
      _$UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$UserStoreBaseActionController.startAction();
    try {
      return super.clear();
    } finally {
      _$UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
