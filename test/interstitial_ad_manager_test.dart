// Tests for the interstitial show-flow orchestrator. It asks AdGate "may I?", and only
// on a yes asks the AdPort to show — recording the show against the frequency budget only
// when an ad actually rendered. Proven against a FakeAdPort: no SDK, no plugins.

import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/features/ads/application/interstitial_ad_manager.dart';
import 'package:plant_care_reminder/features/ads/domain/ad_frequency_controller.dart';
import 'package:plant_care_reminder/features/ads/domain/ad_surface.dart';

import 'support/fake_ad_port.dart';

void main() {
  final sessionStart = DateTime.utc(2026, 7, 3, 12, 0, 0);
  final naturalBreak = sessionStart.add(const Duration(seconds: 90));

  AdFrequencyController freshFrequency() =>
      AdFrequencyController(sessionStart: sessionStart);

  test('does not touch the ad SDK when the gate says no (premium user)', () async {
    final port = FakeAdPort(filled: true);
    final manager = InterstitialAdManager(port: port, frequency: freshFrequency());

    final shown = await manager.maybeShow(
      surface: AdSurface.plantList,
      isPremium: true,
      now: naturalBreak,
    );

    expect(shown, isFalse);
    expect(port.showCalls, 0, reason: 'premium => no SDK call at all');
  });

  test('shows and records when the gate allows and the port has fill', () async {
    final port = FakeAdPort(filled: true);
    final frequency = freshFrequency();
    final manager = InterstitialAdManager(port: port, frequency: frequency);

    final shown = await manager.maybeShow(
      surface: AdSurface.plantList,
      isPremium: false,
      now: naturalBreak,
    );

    expect(shown, isTrue);
    expect(port.showCalls, 1);
    // Recorded against the budget: an immediate second attempt is now paced out.
    expect(frequency.canShowInterstitial(naturalBreak), isFalse);
  });

  test('a no-fill does not consume the pacing budget', () async {
    final port = FakeAdPort(filled: false); // no ad available
    final frequency = freshFrequency();
    final manager = InterstitialAdManager(port: port, frequency: frequency);

    final shown = await manager.maybeShow(
      surface: AdSurface.plantList,
      isPremium: false,
      now: naturalBreak,
    );

    expect(shown, isFalse);
    expect(port.showCalls, 1, reason: 'the gate allowed, so a show was attempted');
    // Nothing rendered, so the window is untouched — the next break can retry.
    expect(frequency.canShowInterstitial(naturalBreak), isTrue);
  });

  test('a successful show paces out the very next attempt', () async {
    final port = FakeAdPort(filled: true);
    final frequency = freshFrequency();
    final manager = InterstitialAdManager(port: port, frequency: frequency);

    final first = await manager.maybeShow(
      surface: AdSurface.plantList,
      isPremium: false,
      now: naturalBreak,
    );
    // Refill so the port itself isn't the reason the second attempt is blocked.
    await port.loadInterstitial();
    final second = await manager.maybeShow(
      surface: AdSurface.plantList,
      isPremium: false,
      now: naturalBreak.add(const Duration(seconds: 10)),
    );

    expect(first, isTrue);
    expect(second, isFalse, reason: 'within the minimum interval after the first');
  });
}
