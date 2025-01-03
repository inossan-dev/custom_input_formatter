import 'dart:async';

import 'package:custom_input_formatter/custom_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomNumberInputFormatter', () {
    group('Constructor parameters validation', () {
      test('should throw assertion if groupBy is less than or equal to 0', () {
        expect(
              () => CustomNumberInputFormatter(groupBy: 0),
          throwsA(isA<AssertionError>()),
        );
        expect(
              () => CustomNumberInputFormatter(groupBy: -1),
          throwsA(isA<AssertionError>()),
        );
      });

      test('should throw assertion if separator is empty', () {
        expect(
              () => CustomNumberInputFormatter(separator: ''),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('Amount format (FormatType.amount)', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter(
          formatType: FormatType.amount,
          separator: ' ',
          groupBy: 3,
        );
      });

      test('should format a simple amount correctly', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '1000'),
        );
        expect(result.text, '1 000');
      });

      test('should format a large amount correctly', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '1000000'),
        );
        expect(result.text, '1 000 000');
      });

      test('should handle empty input correctly', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: '1000'),
          const TextEditingValue(text: ''),
        );
        expect(result.text, '');
      });

      test('should ignore non-numeric characters', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '1a2b3c'),
        );
        expect(result.text, '123');
      });
    });

    group('Phone number format (FormatType.phoneNumber)', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter(
          formatType: FormatType.phoneNumber,
          separator: ' ',
          groupBy: 2,
          maxLength: 10,
        );
      });

      test('should format phone number correctly', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '0798876677'),
        );
        expect(result.text, '07 98 87 66 77');
      });

      test('should respect maximum length', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '07988766778'),
        );
        expect(result.text, '07 98 87 66 77');
      });

      test('should handle partial phone number', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '0798'),
        );
        expect(result.text, '07 98');
      });
    });

    group('Number format (FormatType.number)', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter(
          formatType: FormatType.number,
          separator: '-',
          groupBy: 4,
        );
      });

      test('should format correctly with custom separator', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '12345678'),
        );
        expect(result.text, '1234-5678');
      });

      test('should handle different grouping correctly', () {
        final formatter = CustomNumberInputFormatter(
          formatType: FormatType.number,
          separator: ' ',
          groupBy: 2,
        );
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '123456'),
        );
        expect(result.text, '12 34 56');
      });
    });

    group('Selection handling', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter();
      });

      test('should position cursor at the end of text', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '123456'),
        );
        expect(result.selection.baseOffset, result.text.length);
        expect(result.selection.extentOffset, result.text.length);
      });

      test('should handle selection after formatting', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: '12345'),
          const TextEditingValue(text: '123456'),
        );
        expect(result.selection.isCollapsed, true);
        expect(result.selection.baseOffset, '123 456'.length);
      });
    });
  });
  group('Extended CustomNumberInputFormatter', () {
    group('Credit Card Format', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter(
          formatType: FormatType.creditCard,
        );
      });

      test('should format credit card number correctly', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '4242424242424242'),
        );
        expect(result.text, '4242 4242 4242 4242');
      });

      test('should handle partial credit card number', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '424242'),
        );
        expect(result.text, '4242 42');
      });
    });

    group('Social Security Number Format', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter(
          formatType: FormatType.socialSecurity,
        );
      });

      test('should format SSN correctly', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '123456789'),
        );
        expect(result.text, '123-45-6789');
      });

      test('should handle partial SSN', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '123'),
        );
        expect(result.text, '123');
      });
    });

    group('Bank Account Format', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter(
          formatType: FormatType.bankAccount,
        );
      });

      test('should format bank account number correctly', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '12345678901234567890123'),
        );
        expect(result.text, '1234 5678 9012 3456 7890 123');
      });
    });

    group('Date Format', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter(
          formatType: FormatType.date,
        );
      });

      test('should format complete date correctly', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '31122024'),
        );
        expect(result.text, '31 12 2024');
      });

      test('should handle partial date', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '3112'),
        );
        expect(result.text, '31 12');
      });
    });

    group('Time Format', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter(
          formatType: FormatType.time,
        );
      });

      test('should format complete time correctly', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '235959'),
        );
        expect(result.text, '23 59 59');
      });

      test('should handle partial time', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '2359'),
        );
        expect(result.text, '23 59');
      });
    });

    group('Postal Code Format', () {
      late CustomNumberInputFormatter formatter;

      setUp(() {
        formatter = CustomNumberInputFormatter(
          formatType: FormatType.postalCode,
        );
      });

      test('should not format postal code', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '75001'),
        );
        expect(result.text, '75001');
      });

      test('should respect maximum length', () {
        final result = formatter.formatEditUpdate(
          const TextEditingValue(text: ''),
          const TextEditingValue(text: '750014'),
        );
        expect(result.text, '75001');
      });
    });
  });
}
