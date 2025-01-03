# Custom Input Formatter

A Flutter package providing advanced input formatters for various number formats including amounts, phone numbers, credit cards, and more. This formatter offers flexible formatting options with customizable separators and grouping patterns.

## Breaking Changes in 2.0.0

Version 2.0.0 introduces significant changes to improve formatting capabilities and type safety. If you're upgrading from version 1.x, please note the following changes:

### Constructor Parameter Changes

The `rightToLeft` boolean parameter has been replaced with the new `formatType` enum. To migrate your existing code:

Previous implementation (1.x):
```dart
CustomNumberInputFormatter(
  rightToLeft: true,
  separator: ' ',
  groupBy: 3,
)
```

New implementation (2.0.0):
```dart
CustomNumberInputFormatter(
  formatType: FormatType.amount,  // For right-to-left formatting
  separator: ' ',
  groupBy: 3,
)
```

### Format Type Specification

Instead of manually configuring formatting patterns, you should now use the appropriate `FormatType` for your use case. This ensures consistent formatting across your application:

Previous approach (1.x):
```dart
// Phone number formatting
CustomNumberInputFormatter(
  rightToLeft: false,
  separator: ' ',
  groupBy: 2,
  maxLength: 10,
)
```

New approach (2.0.0):
```dart
// Phone number formatting
CustomNumberInputFormatter(
  formatType: FormatType.phoneNumber,
  // Other parameters are optional as they're preset by the format type
)
```

### Default Values

Format-specific configurations are now handled automatically based on the selected `FormatType`. You no longer need to specify `groupBy` and `maxLength` for standard format types. These will be ignored if a predefined format type is used.



## Features

The package provides comprehensive formatting support for various numeric input types:

- Amount formatting with thousand separators
- Phone number formatting with customizable patterns
- Credit card number formatting (4-digit groups)
- Social security number formatting
- Bank account number formatting
- Date formatting (DD MM YYYY)
- Time formatting (HH MM SS)
- Postal code validation
- Generic number formatting with custom patterns

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_input_formatter: ^2.0.0
```

## Basic Usage

### Format Types

The formatter supports multiple predefined format types:

```dart
TextField(
  inputFormatters: [
    CustomNumberInputFormatter(
      formatType: FormatType.amount,
    ),
  ],
  keyboardType: TextInputType.number,
)
```

Available format types include:
- `FormatType.amount` - For currency amounts (e.g., "1 000 000")
- `FormatType.phoneNumber` - For phone numbers (e.g., "07 98 87 66 77")
- `FormatType.creditCard` - For credit card numbers (e.g., "4242 4242 4242 4242")
- `FormatType.socialSecurity` - For social security numbers (e.g., "123-45-6789")
- `FormatType.bankAccount` - For bank account numbers
- `FormatType.date` - For dates (e.g., "31 12 2024")
- `FormatType.time` - For time (e.g., "23 59 59")
- `FormatType.postalCode` - For postal codes
- `FormatType.number` - For generic numbers

## Advanced Usage

### Custom Formatting Patterns

You can create custom formatting patterns by specifying the separator and group size:

```dart
// Custom grouping pattern (e.g., XX-XXX-XX)
TextField(
  inputFormatters: [
    CustomNumberInputFormatter(
      separator: '-',
      groupBy: 2,
      maxLength: 7,
    ),
  ],
)
```

### Bank Account Number Formatting

```dart
TextField(
  inputFormatters: [
    CustomNumberInputFormatter(
      formatType: FormatType.bankAccount,
      // Will automatically use the pattern: XXXX XXXX XXXX XXXX XXXX XXX
    ),
  ],
)
```

### Date Input Formatting

```dart
TextField(
  inputFormatters: [
    CustomNumberInputFormatter(
      formatType: FormatType.date,
      // Will automatically format as: DD MM YYYY
    ),
  ],
)
```

## Properties

The CustomNumberInputFormatter class accepts the following properties:

| Property    | Type        | Default     | Description                                           |
|------------|-------------|-------------|-------------------------------------------------------|
| separator  | String      | ' '         | Character used to separate groups                     |
| groupBy    | int         | 3           | Number of characters in each group                    |
| maxLength  | int?        | null        | Maximum length (excluding separators)                 |
| formatType | FormatType  | FormatType.number | Type of formatting to apply                     |

### Default Maximum Lengths

Each format type comes with predefined maximum lengths:

- Credit Card: 16 digits
- Social Security: 9 digits
- Postal Code: 5 digits
- Date: 8 digits (DDMMYYYY)
- Time: 6 digits (HHMMSS)

### Format-Specific Grouping Patterns

Pre-configured grouping patterns for specific formats:

- Credit Card: [4, 4, 4, 4]
- Social Security: [3, 2, 4]
- Bank Account: [4, 4, 4, 4, 4, 3]
- Date: [2, 2, 4]
- Time: [2, 2, 2]

## Examples

### Amount Formatting
```dart
// Input: "1000000"
// Output: "1 000 000"
TextField(
  inputFormatters: [
    CustomNumberInputFormatter(
      formatType: FormatType.amount,
    ),
  ],
)
```

### Credit Card Input
```dart
// Input: "4242424242424242"
// Output: "4242 4242 4242 4242"
TextField(
  inputFormatters: [
    CustomNumberInputFormatter(
      formatType: FormatType.creditCard,
    ),
  ],
)
```

### Social Security Number
```dart
// Input: "123456789"
// Output: "123-45-6789"
TextField(
  inputFormatters: [
    CustomNumberInputFormatter(
      formatType: FormatType.socialSecurity,
    ),
  ],
)
```

## Best Practices

1. Always specify the appropriate keyboard type:
```dart
keyboardType: TextInputType.number
```

2. Consider combining with other formatters for additional validation:
```dart
inputFormatters: [
  FilteringTextInputFormatter.digitsOnly,
  CustomNumberInputFormatter(
    formatType: FormatType.amount,
  ),
],
```

3. Handle empty and invalid inputs appropriately in your form validation logic.

## Contribution

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
