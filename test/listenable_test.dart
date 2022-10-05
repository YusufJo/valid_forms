import 'package:test/test.dart';
import 'package:valid_forms/src/listenable.dart';

class _FakeListenable extends Listenable {}

void main() {
  group('$Listenable', () {
    test('should not add the same listener more than once', () {
      // arrange
      final sut = _FakeListenable();
      int notificationCounter = 0;
      void notify() => notificationCounter++;

      // act
      sut.addListener(notify);
      sut.addListener(notify);

      // assert
      expect(notificationCounter, 0);

      // act
      sut.notifyListeners();

      expect(notificationCounter, 1);
    });

    test('should notify all listeners', () {
      // arrange
      final sut = _FakeListenable();
      bool isFirstNotified = false;
      void notifyFirst() => isFirstNotified = true;
      bool isSecondNotified = false;
      void notifySecond() => isSecondNotified = true;
      bool isThirdNotified = false;
      void notifyThird() => isThirdNotified = true;

      // act
      sut.addListener(notifyFirst);
      sut.addListener(notifySecond);
      sut.addListener(notifyThird);

      // assert
      expect(isFirstNotified, isFalse);
      expect(isSecondNotified, isFalse);
      expect(isThirdNotified, isFalse);

      // act
      sut.notifyListeners();

      // assert
      expect(isFirstNotified, isTrue);
      expect(isSecondNotified, isTrue);
      expect(isThirdNotified, isTrue);
    });

    test('should stop notifying removed listeners', () {
      // arrange
      final sut = _FakeListenable();
      int notificationCounter = 0;
      void notify() => notificationCounter++;

      // act
      sut.addListener(notify);

      // assert
      expect(notificationCounter, 0);

      // act
      sut.notifyListeners();

      // assert
      expect(notificationCounter, 1);

      // act
      sut.removeListener(notify);
      sut.notifyListeners();

      // assert
      expect(notificationCounter, 1);
    });

    test('should remove all listeners when instance is disposed', () {
      // arrange
      final sut = _FakeListenable();
      int firstCounter = 0;
      void notifyFirst() => firstCounter++;
      int secondCounter = 0;
      void notifySecond() => secondCounter++;

      // act
      sut.addListener(notifyFirst);
      sut.addListener(notifySecond);

      // assert
      expect(firstCounter, 0);
      expect(secondCounter, 0);

      // act
      sut.notifyListeners();

      // assert
      expect(firstCounter, 1);
      expect(secondCounter, 1);

      // act
      sut.dispose();
      sut.notifyListeners();

      // assert
      expect(firstCounter, 1);
      expect(secondCounter, 1);
    });
  });
}
