// Pure-Dart test for notification-tap deep-linking: the payload a care reminder carries
// (the plant's id) resolves to that plant's detail location — and a missing/blank payload
// resolves to nothing (so a corrupt notification can't route to a broken `/plant/`).

import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/app/router.dart';

void main() {
  test('a plant-id payload resolves to that plant\'s detail location', () {
    expect(notificationRouteFor('abc-123'), Routes.plant('abc-123'));
    expect(notificationRouteFor('abc-123'), '/plant/abc-123');
  });

  test('a null payload resolves to no route', () {
    expect(notificationRouteFor(null), isNull);
  });

  test('an empty or whitespace payload resolves to no route', () {
    expect(notificationRouteFor(''), isNull);
    expect(notificationRouteFor('   '), isNull);
  });
}
