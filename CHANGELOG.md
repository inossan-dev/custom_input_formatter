# Changelog

## [2.0.1] - 2024-01-03

- Update readme

## [2.0.0] - 2024-01-02

This major release introduces comprehensive formatting support for various numeric input types through a new FormatType enum.

### Added
- Introduced FormatType enum for specialized number formatting
- Added support for credit card number formatting (4242 4242 4242 4242)
- Implemented social security number formatting (123-45-6789)
- Added postal code validation and formatting
- Introduced bank account number formatting
- Added date formatting support (DD MM YYYY)
- Implemented time formatting (HH MM SS)
- Added predefined maximum lengths for different format types
- Implemented specialized grouping patterns for each format type

### Changed
- Refactored the core formatting logic to support multiple format types
- Enhanced the constructor to handle format-specific configurations
- Improved separator handling for different format types
- Updated documentation with comprehensive format type examples

### Fixed
- Resolved edge cases in group size calculations
- Improved cursor positioning after formatting
- Enhanced handling of partial inputs

## [1.0.1] - Previous Release

### Fixed
- Resolved package download issues
- Improved package configuration

## [1.0.0] - Initial Release

### Added
- Initial implementation of CustomNumberInputFormatter
- Support for custom group separators
- Right-to-left and left-to-right formatting
- Customizable group size configuration
- Maximum length constraint implementation
- Included example application
- Basic documentation