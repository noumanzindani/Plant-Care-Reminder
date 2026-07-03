// Pure-Dart tests for the rewarded-unlock OFFER decision. The policy decides only whether
// to show the "watch an ad to unlock 1 AI scan" path and which reason to surface -- it
// never grants a credit (the grant is server-authoritative via AdMob SSV). No SDK, no
// backend: the offer rules are proven in isolation.

import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/features/ads/domain/rewarded_unlock_policy.dart';

void main() {
  const policy = RewardedUnlockPolicy(maxUnlocksPerDay: 5);

  test('offers the unlock when out of scans, under the daily cap, not premium', () {
    expect(
      policy.evaluate(
        scanCreditsRemaining: 0,
        rewardedUnlocksToday: 2,
        isPremium: false,
      ),
      RewardedUnlockAvailability.offer,
    );
  });

  test('does not offer while free scans remain', () {
    expect(
      policy.evaluate(
        scanCreditsRemaining: 1,
        rewardedUnlocksToday: 0,
        isPremium: false,
      ),
      RewardedUnlockAvailability.hasCredits,
    );
  });

  test('does not offer once the daily cap is reached', () {
    expect(
      policy.evaluate(
        scanCreditsRemaining: 0,
        rewardedUnlocksToday: 5,
        isPremium: false,
      ),
      RewardedUnlockAvailability.dailyCapReached,
    );
  });

  test('never offers to a premium user', () {
    expect(
      policy.evaluate(
        scanCreditsRemaining: 0,
        rewardedUnlocksToday: 0,
        isPremium: true,
      ),
      RewardedUnlockAvailability.premium,
    );
  });

  test('premium takes precedence even at zero credits and a hit cap', () {
    // A premium user should never be routed into the ad path, whatever the counters say.
    expect(
      policy.evaluate(
        scanCreditsRemaining: 0,
        rewardedUnlocksToday: 5,
        isPremium: true,
      ),
      RewardedUnlockAvailability.premium,
    );
  });

  test('the daily cap blocks at exactly the maximum (inclusive)', () {
    final atCap = policy.evaluate(
      scanCreditsRemaining: 0,
      rewardedUnlocksToday: 5,
      isPremium: false,
    );
    final underCap = policy.evaluate(
      scanCreditsRemaining: 0,
      rewardedUnlocksToday: 4,
      isPremium: false,
    );
    expect(atCap, RewardedUnlockAvailability.dailyCapReached);
    expect(underCap, RewardedUnlockAvailability.offer);
  });
}
