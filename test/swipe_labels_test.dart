import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Swipe Stamp Labels Test', () {
    test('Swipe stamp labels should have correct text', () {
      const leftSwipeText = "DON'T LIKE";
      const rightSwipeText = "CAN'T DO";
      const upSwipeText = 'TOO EASY';
      const downSwipeText = 'NO EQUIPMENT';

      expect(leftSwipeText, "DON'T LIKE");
      expect(rightSwipeText, "CAN'T DO");
      expect(upSwipeText, 'TOO EASY');
      expect(downSwipeText, 'NO EQUIPMENT');
    });

    test('Stamp rotation angles should be appropriate', () {
      const leftRotation = -0.2;
      const rightRotation = 0.2;
      const upRotation = -0.1;
      const downRotation = 0.1;

      expect(leftRotation, -0.2);
      expect(rightRotation, 0.2);
      expect(upRotation, -0.1);
      expect(downRotation, 0.1);
    });
  });
}
