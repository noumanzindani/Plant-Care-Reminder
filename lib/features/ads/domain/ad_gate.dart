import 'ad_frequency_controller.dart';
import 'ad_surface.dart';

/// The single authority a screen asks "may I show an ad here, right now?".
///
/// Composes the three orthogonal gates the plan mandates, in order of authority:
///   1. **Entitlement** — ads are gated entirely behind `isPremium`; a premium user
///      never sees an ad on any surface.
///   2. **Surface** — the hard-rule ad-free surfaces ([AdSurface.allowsAds]).
///   3. **Frequency** — interstitials additionally obey the [AdFrequencyController]
///      pacing rules (banners are persistent and do not consult frequency).
///
/// Stateless and pure: every input is passed in, so each rule is provable in isolation
/// with no SDK, plugin, or wall-clock dependency.
class AdGate {
  const AdGate();

  /// Whether an adaptive banner may render on [surface] for this user.
  bool showBanner({required AdSurface surface, required bool isPremium}) {
    if (isPremium) return false; // entitlement: premium is ad-free everywhere
    return surface.allowsAds; // hard-rule ad-free surfaces
  }

  /// Whether an interstitial may be shown on [surface] at [now], given the
  /// session's [frequency] pacing state.
  bool showInterstitial({
    required AdSurface surface,
    required bool isPremium,
    required AdFrequencyController frequency,
    required DateTime now,
  }) {
    if (isPremium) return false; // entitlement
    if (!surface.allowsAds) return false; // hard-rule ad-free surfaces
    return frequency.canShowInterstitial(now); // pacing (interstitial-only)
  }
}
