import '../domain/ad_frequency_controller.dart';
import '../domain/ad_gate.dart';
import '../domain/ad_port.dart';
import '../domain/ad_surface.dart';

/// Orchestrates a single interstitial show: ask the [AdGate], and only if it says yes
/// ask the [AdPort] to show. This is the one call a screen makes at a natural break.
///
/// Lives in the `application` layer: it's a use-case that composes pure policy
/// ([AdGate] + [AdFrequencyController]) with a side-effecting adapter ([AdPort]) —
/// the same split as the sync layer's `SyncService` over `SyncApiPort`.
class InterstitialAdManager {
  InterstitialAdManager({
    required AdPort port,
    required AdFrequencyController frequency,
    AdGate gate = const AdGate(),
  })  : _port = port,
        _frequency = frequency,
        _gate = gate;

  final AdPort _port;
  final AdFrequencyController _frequency;
  final AdGate _gate;

  /// Attempt to show an interstitial on [surface] at [now]. Returns `true` iff an ad
  /// actually rendered.
  Future<bool> maybeShow({
    required AdSurface surface,
    required bool isPremium,
    required DateTime now,
  }) async {
    final allowed = _gate.showInterstitial(
      surface: surface,
      isPremium: isPremium,
      frequency: _frequency,
      now: now,
    );
    if (!allowed) return false; // never wake the SDK when policy forbids it

    final shown = await _port.showInterstitialIfReady();
    // Only a rendered ad consumes the pacing budget; a no-fill leaves it for next break.
    if (shown) _frequency.recordInterstitialShown(now);
    return shown;
  }
}
