import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CookieState {
  String _cookie;

  get cookie => _cookie;

  CookieState(this._cookie);
}

enum Action { saveCookie }

CookieState reducer(CookieState state, action) {
  if(action == Action.saveCookie){
    return CookieState(state.cookie);
  }else{
    return state;
  }
}
