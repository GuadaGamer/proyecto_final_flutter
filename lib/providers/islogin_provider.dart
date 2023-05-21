import 'package:flutter/material.dart';

class FlagsProvider with ChangeNotifier {
  bool _flagsListPost = false;

  getflagListPost() => this._flagsListPost;
  setflagListPost() {
    this._flagsListPost = !_flagsListPost;
    notifyListeners();
  }
}