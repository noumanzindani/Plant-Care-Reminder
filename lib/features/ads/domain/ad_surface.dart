/// Where in the app an ad decision is being made.
///
/// The plan defines certain surfaces as **ad-free (a hard rule)** — onboarding, the
/// camera/scanner/AI-result flow, the paywall, the "complete a reminder" moment,
/// account/settings/delete-account/auth, and the first screen after a push deep-link.
/// Banners are permitted only on *secondary* list/browse screens. That per-surface rule
/// is encoded here as data via [allowsAds]; entitlement and frequency are layered on top
/// by `AdGate` (they are policy, this is the fixed map).
enum AdSurface {
  // ── Ad-free surfaces (hard rule) ──────────────────────────────────────────
  /// First-run onboarding / value walkthrough.
  onboarding,

  /// Camera / scanner / AI identification result — a focused, trust-sensitive flow.
  scanner,

  /// The premium paywall itself (never distract from the upsell).
  paywall,

  /// The "complete a reminder" action — the core value moment must stay clean.
  reminderCompletion,

  /// Account / settings / delete-account / auth screens.
  account,

  /// The first screen shown after tapping a push deep-link.
  pushLanding,

  // ── Ad-supported secondary list/browse screens ────────────────────────────
  /// Browsing the list of the user's plants.
  plantList,

  /// Browsing / searching the species catalog.
  speciesBrowse,

  /// The journal / care-history list.
  journal,

  /// The community feed (native ads in-feed later; still an ad-supported surface).
  communityFeed;

  /// Whether ad units may render on this surface at all, *before* entitlement and
  /// frequency are considered. `false` for the hard-rule ad-free surfaces above.
  bool get allowsAds => switch (this) {
        onboarding ||
        scanner ||
        paywall ||
        reminderCompletion ||
        account ||
        pushLanding =>
          false,
        plantList || speciesBrowse || journal || communityFeed => true,
      };
}
