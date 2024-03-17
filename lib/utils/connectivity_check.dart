import 'dart:async'; //For StreamController/Stream
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart'; //InternetAddress utility


class ConnectionStatus {
  static final ConnectionStatus _connectionStatus =
      ConnectionStatus._internal();

  ConnectionStatus._internal();

  factory ConnectionStatus() {
    return _connectionStatus;
  }

  ///This tracks the current connection status
  bool hasConnection = false;

  ///This is how we'll allow subscribing to connection changes
  late StreamController connectionChangeController;

  ///Using Connectivity package here
  final Connectivity _connectivity = Connectivity();

  ///Method called when main() is called on app launch
  void initialize() {
    connectionChangeController = StreamController.broadcast();

    ///Listen to Connectivity package's Stream to listen for changes
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  ///Access to controller's stream to keep UI in sync with network state
  Stream get connectionChange => connectionChangeController.stream;

  ///A clean up method to close our StreamController
  ///Because this is meant to exist through the entire application life cycle this isn't
  ///really an issue
  void dispose() {
    connectionChangeController.close();
  }

  ///Call check connection to see if internet is available
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  ///Test method to see if the internet is actually available
  Future<bool> checkConnection() async {
    // Logger.singleLine('Here in check connection aync');
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    ///If connection status changes than send it to the controller
    ///for the UI to change accordingly
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
