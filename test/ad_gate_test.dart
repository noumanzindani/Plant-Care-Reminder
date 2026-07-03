// Pure-Dart tests for the ad-decision brain. AdGate is the single authority a screen
// asks "may I show an ad here, right now?" It layers three orthogonal gates — entitlement
// (premium => zero ads), surface (hard-rule ad-free zones), and, for interstitials only,
// the AdFrequencyController pacing. No SDK, no plugins: the gating rules are proven in
// isolation before any AdMob code exists, and a mis-gated ad is both a policy risk and a
// retention killer.

import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/features/ads/domain/ad_frequency_controller.dart';
import 'package:plant_care_reminder/features/ads/domain/ad_gate.dart';
import 'package:plant_care_reminder/features/ads/domain/ad_surface.dart';

void main() {
  const gate = AdGate();
  final sessionStart = DateTime.utc(2026, 7, 3, 12, 0, 0);

  // A frequency controller sitting at a "natural break" — past the cold-start grace,
  // nothing shown yet, so it would say yes on its own.
  AdFrequencyController readyFrequency() =>
      AdFrequencyController(sessionStart: sessionStart);
  final naturalBreak = sessionStart.add(const Duration(seconds: 90));

  group('banners', () {
    test('a premium user sees no banner, even on an ad-supported surface', () {
      expect(
        gate.showBanner(surface: AdSurface.speciesBrowse, isPremium: true),
        isFalse,
      );
    });

    test('a free user sees a banner on a secondary browse surface', () {
      expect(
        gate.showBanner(surface: AdSurface.speciesBrowse, isPremium: false),
        isTrue,
      );
    });

    test('a free user sees no banner on a hard-rule ad-free surface', () {
      expect(
        gate.showBanner(surface: AdSurface.scanner, isPremium: false),
        isFalse,
      );
    });
  });

  group('interstitials', () {
    test('a premium user gets no interstitial even when surface and pacing allow', () {
      expect(
        gate.showInterstitial(
          surface: AdSurface.plantList,
          isPremium: true,
          frequency: readyFrequency(),
          now: naturalBreak,
        ),
        isFalse,
      );
    });

    test('no interstitial on an ad-free surface even when pacing allows', () {
      expect(
        gate.showInterstitial(
          surface: AdSurface.reminderCompletion,
          isPremium: false,
          frequency: readyFrequency(),
          now: naturalBreak,
        ),
        isFalse,
      );
    });

    test('a free user gets an interstitial at a natural break on an ad-supported surface', () {
      expect(
        gate.showInterstitial(
          surface: AdSurface.plantList,
          isPremium: false,
          frequency: readyFrequency(),
          now: naturalBreak,
        ),
        isTrue,
      );
    });

    test('the gate delegates pacing: no interstitial during the cold-start grace', () {
      final coldStart = sessionStart.add(const Duration(seconds: 30));
      expect(
        gate.showInterstitial(
          surface: AdSurface.plantList,
          isPremium: false,
          frequency: readyFrequency(),
          now: coldStart,
        ),
        isFalse,
      );
    });
  });

  test('banners ignore frequency — shown during the interstitial cold-start grace', () {
    // The banner path must not consult the AdFrequencyController: a banner is fine
    // on a browse screen even in the first seconds after launch, when an interstitial
    // would be blocked. Same free user, same surface, same instant — banner yes.
    expect(
      gate.showBanner(surface: AdSurface.plantList, isPremium: false),
      isTrue,
    );
    expect(
      gate.showInterstitial(
        surface: AdSurface.plantList,
        isPremium: false,
        frequency: readyFrequency(),
        now: sessionStart.add(const Duration(seconds: 5)),
      ),
      isFalse,
    );
  });
}
