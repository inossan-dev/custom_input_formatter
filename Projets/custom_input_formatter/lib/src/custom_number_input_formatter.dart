import 'package:flutter/services.dart';

/// A [TextInputFormatter] that can format both amounts (right-to-left) and numbers (left-to-right).
/// Examples:
/// - Amounts (rightToLeft: true): 1000000 -> 1 000 000
/// - Numbers (rightToLeft: false): 0798876677 -> 07 98 87 66 77
class CustomNumberInputFormatter extends TextInputFormatter {
  /// The character used to separate groups
  final String separator;

  /// The number of characters before adding a separator
  final int groupBy;

  /// Maximum length of the input (excluding separators)
  final int? maxLength;

  /// Whether to group digits from right to left (true for amounts) or left to right (false for numbers)
  final bool rightToLeft;

  CustomNumberInputFormatter({
    this.separator = ' ',
    this.groupBy = 3,
    this.maxLength,
    this.rightToLeft = false,
  })  : assert(groupBy > 0, 'groupBy must be greater than 0'),
        assert(separator.isNotEmpty, 'separator must not be empty'),
        assert(maxLength == null || maxLength > 0,
            'maxLength must be greater than 0');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Return empty value if the new input is empty
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all existing separators
    String cleanText = newValue.text.replaceAll(separator, '');

    // Apply maxLength constraint if specified
    if (maxLength != null && cleanText.length > maxLength!) {
      cleanText = cleanText.substring(0, maxLength!);
    }

    // Format the text based on the direction
    final formattedText = rightToLeft
        ? _formatTextRightToLeft(cleanText)
        : _formatTextLeftToRight(cleanText);

    // Always position cursor at the end of the text
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  /// Formats the text by adding separators, grouping from right to left (for amounts)
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

  /// Formats the text by adding separators, grouping from left to right (for numbers)
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
