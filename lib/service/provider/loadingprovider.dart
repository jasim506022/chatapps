import 'package:flutter/foundation.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setLoadingValue({required bool loadingValue}) {
    _isLoading = loadingValue;
    notifyListeners();
  }
}
