import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/ports/connectivity_port.dart';

/// Production [ConnectivityPort] over `connectivity_plus`. "Online" means at least one active
/// transport that isn't `none` — a coarse gate; the sync engine's own request failures handle
/// the captive-portal / connected-but-no-internet cases.
class ConnectivityPlusAdapter implements ConnectivityPort {
  ConnectivityPlusAdapter([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
