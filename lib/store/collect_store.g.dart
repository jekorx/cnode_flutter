// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collect_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CollectStore on CollectStoreBase, Store {
  Computed<List<String>> _$collectIdsComputed;

  @override
  List<String> get collectIds =>
      (_$collectIdsComputed ??= Computed<List<String>>(() => super.collectIds))
          .value;

  final _$collectsAtom = Atom(name: 'CollectStoreBase.collects');

  @override
  ObservableList<Topic> get collects {
    _$collectsAtom.context.enforceReadPolicy(_$collectsAtom);
    _$collectsAtom.reportObserved();
    return super.collects;
  }

  @override
  set collects(ObservableList<Topic> value) {
    _$collectsAtom.context.conditionallyRunInAction(() {
      super.collects = value;
      _$collectsAtom.reportChanged();
    }, _$collectsAtom, name: '${_$collectsAtom.name}_set');
  }

  final _$CollectStoreBaseActionController =
      ActionController(name: 'CollectStoreBase');

  @override
  void setAll(List<Topic> topics) {
    final _$actionInfo = _$CollectStoreBaseActionController.startAction();
    try {
      return super.setAll(topics);
    } finally {
      _$CollectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void add(Topic topic) {
    final _$actionInfo = _$CollectStoreBaseActionController.startAction();
    try {
      return super.add(topic);
    } finally {
      _$CollectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void remove(String id) {
    final _$actionInfo = _$CollectStoreBaseActionController.startAction();
    try {
      return super.remove(id);
    } finally {
      _$CollectStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$CollectStoreBaseActionController.startAction();
    try {
      return super.clear();
    } finally {
      _$CollectStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
