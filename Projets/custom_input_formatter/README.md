# Custom Input Formatter

A Flutter package providing customizable input formatters for amounts and numbers with group separators.

## Features

- Format numbers with custom group separators
- Support for both right-to-left (amounts) and left-to-right (numbers) formatting
- Customizable group size
- Optional maximum length constraint
- Automatic cursor positioning

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  custom_input_formatter: ^1.0.0
```

## Usage

### Format a phone number (grouped by 2)

```dart
TextField(
  inputFormatters: [
    CustomNumberInputFormatter(
      separator: ' ',
      groupBy: 2,
      maxLength: 10,
      rightToLeft: false,
    ),
  ],
  keyboardType: TextInputType.number,
)
```

### Format an amount (grouped by 3)

```dart
TextField(
  inputFormatters: [
    CustomNumberInputFormatter(
      separator: ' ',
      groupBy: 3,
      maxLength: 7,
      rightToLeft: true,
    ),
  ],
  keyboardType: TextInputType.number,
)
```

## Parameters

- `separator`: The character used to separate groups (default: ' ')
- `groupBy`: The number of characters in each group (default: 3)
- `maxLength`: Optional maximum length of the input (excluding separators)
- `rightToLeft`: Whether to group digits from right to left (true for amounts) or left to right (false for numbers)

## Examples

- Phone number: "0798876677" → "07 98 87 66 77"
- Amount: "1000000" → "1 000 000"

## Additional information

For more examples, check out the example app in the `example` directory.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.