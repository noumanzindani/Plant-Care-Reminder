/// The seam between the app's ad *decisions* and the ad *SDK*.
///
/// The real adapter (later) wraps `google_mobile_ads`; tests use a fake. Only the
/// imperative interstitial lifecycle lives here — banners are widgets rendered at the
/// view layer, so they need no port. Keeping the surface minimal keeps the fake honest.
abstract interface class AdPort {
  /// Begin loading an interstitial so one is ready at the next natural break.
  /// Fire-and-forget; fill is not guaranteed.
  Future<void> loadInterstitial();

  /// Show a preloaded interstitial if one is ready, consuming it.
  ///
  /// Returns `true` if an ad actually rendered, `false` if none was ready (no fill).
  /// The caller uses this to decide whether the show truly happened.
  Future<bool> showInterstitialIfReady();
}
