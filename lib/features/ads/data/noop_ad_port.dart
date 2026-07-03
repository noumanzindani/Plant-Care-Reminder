import '../domain/ad_port.dart';

/// An [AdPort] that never has fill — the safe default until the real `google_mobile_ads`
/// adapter (and an AdMob account) exist.
///
/// With this bound, the ad provider graph composes and the app runs with zero ad
/// behavior; swapping this for the real adapter is the only step left to turn
/// interstitials on. Mirrors how the sync graph shipped behind a fake before real HTTP.
class NoopAdPort implements AdPort {
  const NoopAdPort();

  @override
  Future<void> loadInterstitial() async {}

  @override
  Future<bool> showInterstitialIfReady() async => false;
}
