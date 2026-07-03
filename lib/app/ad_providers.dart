import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/ads/application/interstitial_ad_manager.dart';
import '../features/ads/data/noop_ad_port.dart';
import '../features/ads/domain/ad_frequency_controller.dart';
import '../features/ads/domain/ad_gate.dart';
import '../features/ads/domain/ad_port.dart';

/// Whether the current user is premium. Ads are gated entirely behind this.
///
/// Free-tier default (`false`) so everyone sees ads and the app runs with no account.
/// TODO: read the synced server-authoritative entitlement (`users.is_premium`) once the
/// signed-in user state is exposed; until then, no one is premium.
final isPremiumProvider = Provider<bool>((ref) => false);

/// The single ad-decision authority a screen asks "may I show an ad here, right now?".
final adGateProvider = Provider<AdGate>((ref) => const AdGate());

/// Session-scoped interstitial pacing. `sessionStart` is when the ad subsystem first
/// initializes for this app run — the anchor for the cold-start grace window.
final adFrequencyControllerProvider = Provider<AdFrequencyController>(
  (ref) => AdFrequencyController(sessionStart: DateTime.now()),
);

/// The ad SDK seam. Swap point: this [NoopAdPort] gives way to the real
/// `google_mobile_ads` adapter once an AdMob account + native app IDs exist.
final adPortProvider = Provider<AdPort>((ref) => const NoopAdPort());

/// The interstitial show-flow a screen calls at a natural break: it consults
/// [adGateProvider] and only then wakes the SDK.
final interstitialAdManagerProvider = Provider<InterstitialAdManager>(
  (ref) => InterstitialAdManager(
    port: ref.watch(adPortProvider),
    frequency: ref.watch(adFrequencyControllerProvider),
    gate: ref.watch(adGateProvider),
  ),
);
