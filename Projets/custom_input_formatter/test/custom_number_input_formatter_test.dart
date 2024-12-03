import 'package:flutter_test/flutter_test.dart';
import 'package:custom_input_formatter/custom_input_formatter.dart';

void main() {
  group('CustomNumberInputFormatter', () {
    test('formats numbers from left to right correctly', () {
      final formatter = CustomNumberInputFormatter(
        separator: ' ',
        groupBy: 2,
        maxLength: 10,
        rightToLeft: false,
      );

      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '0798876677'),
      );

      expect(result.text, '07 98 87 66 77');
    });

    test('formats amounts from right to left correctly', () {
      final formatter = CustomNumberInputFormatter(
        separator: ' ',
        groupBy: 3,
        maxLength: 7,
        rightToLeft: true,
      );

      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '1000000'),
      );

      expect(result.text, '1 000 000');
    });

    test('respects maxLength constraint', () {
      final formatter = CustomNumberInputFormatter(
        maxLength: 5,
        rightToLeft: false,
      );

      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '123456'),
      );

      expect(result.text, '12 345');
    });

    test('handles empty input correctly', () {
      final formatter = CustomNumberInputFormatter();

      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '123'),
        const TextEditingValue(text: ''),
      );

      expect(result.text, '');
    });
  });
}