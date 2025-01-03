import 'package:flutter/services.dart';

enum FormatType {
  /// Format for amounts (e.g., 1 000 000)
  amount,

  /// Format for phone numbers (e.g., 07 98 87 66 77)
  phoneNumber,

  /// Format for generic numbers (e.g., 123 456)
  number,

  /// Format for credit card numbers (e.g., 4242 4242 4242 4242)
  creditCard,

  /// Format for social security numbers (e.g., 123-45-6789)
  socialSecurity,

  /// Format for postal codes (e.g., 75001)
  postalCode,

  /// Format for bank account numbers (e.g., FR76 3000 6000 0123 4567 8900 189)
  bankAccount,

  /// Format for dates (e.g., 31 12 2024)
  date,

  /// Format for time (e.g., 23 59 59)
  time
}

/// A [TextInputFormatter] that only allows digits and formats with a predefined separator.
class CustomNumberInputFormatter extends TextInputFormatter {
  /// The character used as separator
  final String separator;

  /// Number of characters before adding a separator
  final int groupBy;

  /// Maximum input length (excluding separators)
  final int? maxLength;

  /// The type of formatting to apply
  final FormatType formatType;

  /// Regular expression to validate only digits
  final RegExp _numberRegExp = RegExp(r'[0-9]');

  /// Specific length requirements for different format types
  static const Map<FormatType, int> _defaultMaxLengths = {
    FormatType.creditCard: 16,
    FormatType.socialSecurity: 9,
    FormatType.postalCode: 5,
    FormatType.date: 8, // DDMMYYYY
    FormatType.time: 6, // HHMMSS
  };

  /// Specific grouping requirements for different format types
  static const Map<FormatType, List<int>> _groupingSizes = {
    FormatType.creditCard: [4, 4, 4, 4],
    FormatType.socialSecurity: [3, 2, 4],
    FormatType.bankAccount: [4, 4, 4, 4, 4, 3],
    FormatType.date: [2, 2, 4],
    FormatType.time: [2, 2, 2],
  };

  CustomNumberInputFormatter({
    this.separator = ' ',
    this.groupBy = 3,
    int? maxLength,
    this.formatType = FormatType.number,
  }) : maxLength = maxLength ?? _defaultMaxLengths[formatType],
        assert(groupBy > 0, 'groupBy must be greater than 0'),
        assert(separator.isNotEmpty, 'separator must not be empty');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove existing separators
    String cleanText = newValue.text.replaceAll(separator, '');

    // Keep only digits
    String numbersOnly = cleanText.split('')
        .where((char) => _numberRegExp.hasMatch(char))
        .join();

    // Apply length constraint if specified
    if (maxLength != null && numbersOnly.length > maxLength!) {
      numbersOnly = numbersOnly.substring(0, maxLength!);
    }

    if (numbersOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format according to type
    final formattedText = _applySpecialFormatting(numbersOnly);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _applySpecialFormatting(String text) {
    switch (formatType) {
      case FormatType.creditCard:
        return _formatWithGroups(text, _groupingSizes[FormatType.creditCard]!);
      case FormatType.socialSecurity:
        return _formatWithGroups(text, _groupingSizes[FormatType.socialSecurity]!, separator: '-');
      case FormatType.bankAccount:
        return _formatWithGroups(text, _groupingSizes[FormatType.bankAccount]!);
      case FormatType.date:
        return _formatDate(text);
      case FormatType.time:
        return _formatTime(text);
      case FormatType.amount:
        return _formatTextRightToLeft(text);
      case FormatType.postalCode:
        return text; // No formatting for postal codes
      default:
        return _formatTextLeftToRight(text);
    }
  }

  String _formatWithGroups(String text, List<int> groups, {String? separator}) {
    final buffer = StringBuffer();
    var currentPosition = 0;

    for (var i = 0; i < groups.length && currentPosition < text.length; i++) {
      if (i > 0) {
        buffer.write(separator ?? this.separator);
      }
      final groupSize = groups[i];
      final end = currentPosition + groupSize;
      buffer.write(text.substring(currentPosition, end.clamp(0, text.length)));
      currentPosition = end;
    }

    return buffer.toString();
  }

  String _formatDate(String text) {
    if (text.length < 8) return _formatWithGroups(text, [2, 2, text.length - 4]);
    return _formatWithGroups(text, _groupingSizes[FormatType.date]!);
  }

  String _formatTime(String text) {
    if (text.length < 6) return _formatWithGroups(text, [2, 2, text.length - 4]);
    return _formatWithGroups(text, _groupingSizes[FormatType.time]!);
  }

  String _formatTextRightToLeft(String text) {
    if (text.isEmpty) return '';

    final buffer = StringBuffer();
    final digits = text.split('').reversed.toList();

    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % groupBy == 0) {
        buffer.write(separator);
      }
      buffer.write(digits[i]);
    }

    return buffer.toString().split('').reversed.join();
  }

  String _formatTextLeftToRight(String text) {
    if (text.isEmpty) return '';

    final buffer = StringBuffer();
    final length = text.length;

    for (var i = 0; i < length; i++) {
      if (i > 0 && i % groupBy == 0) {
        buffer.write(separator);
      }
      buffer.write(text[i]);
    }

    return buffer.toString();
  }
}
