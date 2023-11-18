import 'package:chat_ju/model/userpersonmodel.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  bool _isSearch = false;

  final List<UserPersonModel> _seachingList = [];

  List<UserPersonModel> get seachingList => _seachingList;
  
  clearSearch() {
    _seachingList.clear();
  }

  addUsersearch({required UserPersonModel userPersonModel}){
    _seachingList.add(userPersonModel);
    notifyListeners();
  }

  bool get isSearch => _isSearch;

  setSearch({bool? search}) {
    if (search == null) {
      _isSearch = !_isSearch;
    } else {
      _isSearch = search;
    }
    notifyListeners();
  }
}
