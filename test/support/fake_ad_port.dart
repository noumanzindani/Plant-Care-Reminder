import 'package:plant_care_reminder/features/ads/domain/ad_port.dart';

/// In-memory [AdPort] test double. Scriptable fill (`filled`) and call recording, so a
/// manager's show-flow can be proven without the AdMob SDK.
class FakeAdPort implements AdPort {
  FakeAdPort({this.filled = true});

  /// Whether a preloaded interstitial is currently available to show.
  bool filled;

  int loadCalls = 0;
  int showCalls = 0;

  @override
  Future<void> loadInterstitial() async {
    loadCalls++;
    filled = true;
  }

  @override
  Future<bool> showInterstitialIfReady() async {
    showCalls++;
    if (!filled) return false;
    filled = false; // consumed on show
    return true;
  }
}
