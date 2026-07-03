/// Decides whether an interstitial ad may be shown right now.
///
/// Pure policy, driven by wall-clock instants passed in (no `Clock`/plugin dependency), so
/// the pacing rules are provable in isolation. The ad SDK adapter asks this brain "may I?"
/// before loading/showing — it never decides pacing itself.
class AdFrequencyController {
  AdFrequencyController({
    required DateTime sessionStart,
    Duration minSinceStart = const Duration(seconds: 60),
    Duration minInterval = const Duration(seconds: 90),
    int maxPerSession = 4,
  })  : _sessionStart = sessionStart,
        _minSinceStart = minSinceStart,
        _minInterval = minInterval,
        _maxPerSession = maxPerSession;

  final DateTime _sessionStart;
  final Duration _minSinceStart;
  final Duration _minInterval;
  final int _maxPerSession;

  DateTime? _lastShownAt;
  int _shownThisSession = 0;

  /// Whether an interstitial is allowed as of [now].
  bool canShowInterstitial(DateTime now) {
    // No interstitial in the first moments after launch — it's jarring and hurts retention.
    if (now.difference(_sessionStart) < _minSinceStart) return false;

    // Cap the total per session — a wall of ads drives uninstalls.
    if (_shownThisSession >= _maxPerSession) return false;

    // Space ads out — back-to-back interstitials are the fastest way to get uninstalled.
    final lastShown = _lastShownAt;
    if (lastShown != null && now.difference(lastShown) < _minInterval) return false;

    return true;
  }

  /// Record that an interstitial was shown at [now]; feeds the spacing and session rules.
  void recordInterstitialShown(DateTime now) {
    _lastShownAt = now;
    _shownThisSession++;
  }
}
