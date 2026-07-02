/// Whether the device currently has a network path. Pure port so sync gating is testable
/// without the platform plugin; the production adapter wraps `connectivity_plus`.
abstract interface class ConnectivityPort {
  Future<bool> isOnline();
}
