/// Why the "watch an ad to unlock 1 AI scan" path is (or isn't) offered.
///
/// The UI uses the reason to show the right thing: the intro sheet when [offer], nothing
/// when the user [hasCredits], and a "Go Premium" nudge when [dailyCapReached].
enum RewardedUnlockAvailability {
  /// Out of free scans, under the daily cap, not premium — show the opt-in intro sheet.
  offer,

  /// Free scans remain; the rewarded path isn't needed yet.
  hasCredits,

  /// Daily rewarded-unlock cap reached — suggest Premium instead of another ad.
  dailyCapReached,

  /// Premium users have unlimited scans and never see this flow.
  premium,
}

/// Decides whether to *offer* a rewarded unlock. It never grants anything: the grant is
/// server-authoritative (AdMob SSV -> Laravel increments the quota, client re-reads), so
/// no scan credit is ever minted on the device. Pure and input-driven — provable with no
/// SDK, no backend.
class RewardedUnlockPolicy {
  const RewardedUnlockPolicy({this.maxUnlocksPerDay = 5});

  /// Cap on rewarded unlocks per calendar day (server-enforced; mirrored here only to
  /// decide what to show).
  final int maxUnlocksPerDay;

  /// Evaluate the offer for a user with [scanCreditsRemaining] free scans left, who has
  /// already redeemed [rewardedUnlocksToday] rewarded unlocks today.
  RewardedUnlockAvailability evaluate({
    required int scanCreditsRemaining,
    required int rewardedUnlocksToday,
    required bool isPremium,
  }) {
    if (isPremium) return RewardedUnlockAvailability.premium;
    if (scanCreditsRemaining > 0) return RewardedUnlockAvailability.hasCredits;
    if (rewardedUnlocksToday >= maxUnlocksPerDay) {
      return RewardedUnlockAvailability.dailyCapReached;
    }
    return RewardedUnlockAvailability.offer;
  }
}
