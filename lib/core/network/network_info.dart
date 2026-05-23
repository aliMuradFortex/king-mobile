import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity _connectivity = Connectivity();

  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
