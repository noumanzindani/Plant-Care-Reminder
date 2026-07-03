// Pure-Dart tests for the interstitial pacing brain — decides whether an interstitial ad
// may be shown right now, given how long since launch, since the last ad, and how many
// this session. No SDK, no plugins: bad ad pacing kills retention (and therefore revenue),
// so this policy is proven in isolation before any AdMob code exists.

import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/features/ads/domain/ad_frequency_controller.dart';

void main() {
  final sessionStart = DateTime.utc(2026, 7, 3, 12, 0, 0);

  test('does not show an interstitial during the cold-start grace window', () {
    final controller = AdFrequencyController(
      sessionStart: sessionStart,
      minSinceStart: const Duration(seconds: 60),
    );

    // 30s after launch — still inside the 60s cold-start grace.
    final now = sessionStart.add(const Duration(seconds: 30));
    expect(controller.canShowInterstitial(now), isFalse);
  });

  test('allows an interstitial after the grace window when none have shown', () {
    final controller = AdFrequencyController(
      sessionStart: sessionStart,
      minSinceStart: const Duration(seconds: 60),
    );

    final now = sessionStart.add(const Duration(seconds: 90));
    expect(controller.canShowInterstitial(now), isTrue);
  });

  test('blocks a second interstitial within the minimum interval', () {
    final controller = AdFrequencyController(
      sessionStart: sessionStart,
      minSinceStart: const Duration(seconds: 60),
      minInterval: const Duration(seconds: 90),
    );

    final firstShow = sessionStart.add(const Duration(seconds: 90));
    controller.recordInterstitialShown(firstShow);

    // 30s later — under the 90s minimum gap.
    final now = firstShow.add(const Duration(seconds: 30));
    expect(controller.canShowInterstitial(now), isFalse);
  });

  test('allows another interstitial once the interval has elapsed', () {
    final controller = AdFrequencyController(
      sessionStart: sessionStart,
      minSinceStart: const Duration(seconds: 60),
      minInterval: const Duration(seconds: 90),
    );

    final firstShow = sessionStart.add(const Duration(seconds: 90));
    controller.recordInterstitialShown(firstShow);

    // 120s later — past the 90s gap.
    final now = firstShow.add(const Duration(seconds: 120));
    expect(controller.canShowInterstitial(now), isTrue);
  });

  test('stops showing interstitials once the per-session cap is reached', () {
    final controller = AdFrequencyController(
      sessionStart: sessionStart,
      minSinceStart: const Duration(seconds: 60),
      minInterval: const Duration(seconds: 90),
      maxPerSession: 2,
    );

    var t = sessionStart.add(const Duration(seconds: 90));
    controller.recordInterstitialShown(t); // 1st
    t = t.add(const Duration(seconds: 120));
    controller.recordInterstitialShown(t); // 2nd (cap)
    t = t.add(const Duration(seconds: 120));

    // Cap reached, even though grace and interval are both satisfied.
    expect(controller.canShowInterstitial(t), isFalse);
  });
}
