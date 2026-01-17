# QRIS Parser

A Dart package for parsing QRIS (Quick Response Code Indonesian Standard) strings, based on the **EMVCo QR Code Specification for Payment Systems (EMV QRCPS)**.

This package enables you to break down a valid QRIS code into pieces of useful information, such as the merchant name, transaction amount, city, postal code, and validation status (CRC).

## Features

- **Standard Compliance**: Parses QRIS strings according to standard TLV (Tag-Length-Value) formatting.
- **Data Extraction**: Easily access fields like Merchant Name, City, Postal Code, Currency, and Amount.
- **CRC Validation**: Automatically verifies the CRC16-CCITT checksum to ensure data integrity.
- **Nested Parsing**: Supports parsing of nested objects like Merchant Account Information (ID 26-51) and Additional Data Fields (ID 62).
- **Pure Dart**: Zero dependencies on Flutter, meaning it runs on server-side Dart, CLIs, and generic web apps too.

## Usage

Here is a simple example of how to use the package.

```dart
import 'package:qris_parser/qris_parser.dart';

void main() {
  // Example: "Fulung Store" QRIS
  String qrisData = '00020101021126570011ID.DANA.WWW011893600915387258349102098725834910303UMI51440014ID.CO.QRIS.WWW0215ID10253905048490303UMI5204481453033605802ID5912Fulung Store6014Kota Palembang61053011163047279';

  try {
    // Parse the data
    Qris qris = Qris.parse(qrisData);

    // Access the properties
    print('Merchant Name: ${qris.merchantName}');
    // Output: Fulung Store

    print('City: ${qris.merchantCity}');
    // Output: Kota Palembang

    print('CRC: ${qris.crc}');
    // Output: 7279

    // Check specific merchant account info (e.g. ID 26)
    if (qris.merchantAccountInformation.containsKey(26)) {
       print('Merchant Criteria: ${qris.merchantAccountInformation[26]?.criteria}');
    }

  } on QrisError catch (e) {
    print('Failed to parse: $e');
  }
}
```

## Flutter Integration

This package is **pure Dart**, which means it works seamlessly with Flutter. You typically use it alongside a QR scanning library (such as `mobile_scanner` or `qr_code_scanner`).

### Example with `mobile_scanner`

```dart
MobileScanner(
  onDetect: (capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        try {
          // Parse the QRIS string from the scanner
          final qris = Qris.parse(barcode.rawValue!);

          // Data is valid Navigate to payment screen
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => PaymentScreen(
              merchantName: qris.merchantName,
              amount: qris.transactionAmount,
            )
          ));

        } on QrisError catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid QRIS Code!')),
          );
        }
      }
    }
  },
)
```

## Reading from Image File/Gallery

If you need to scan a QRIS code from an image file (e.g., from the gallery), you can use plugins like `mobile_scanner` or `google_ml_kit`.

```dart
// Pseudo-code example using file picker and scanner
Future<void> scanFromGallery() async {
  final file = await FilePicker.platform.pickFiles();
  if (file != null) {
    // Use your preferred scanner library's 'analyzeImage' function
    final String? code = await scanner.analyzeImage(file.files.single.path!);

    if (code != null) {
      final qris = Qris.parse(code);
      print(qris.merchantName);
    }
  }
}
```

## Supported Fields

The parser currently supports extracting the following standard fields:

- **Payload Format Indicator** (ID 00)
- **Point of Initiation Method** (ID 01)
- **Merchant Account Information** (ID 26-51)
- **Merchant Category Code** (ID 52)
- **Transaction Currency** (ID 53)
- **Transaction Amount** (ID 54)
- **Tip/Convenience Indicator** (ID 55)
- **Fees** (ID 56, 57)
- **Country Code** (ID 58)
- **Merchant Name** (ID 59)
- **Merchant City** (ID 60)
- **Postal Code** (ID 61)
- **Additional Data Field** (ID 62)
- **CRC** (ID 63)

## TO-DOs

- [ ] Add more helper getters for specific merchant criteria.
- [ ] Add support for generating QRIS strings (Builder pattern).
- [ ] Improve error messages with more context.

## License

MIT
