# QRIS Parser (Dart / Flutter)

QRIS Parser is a Dart package for parsing **QRIS (EMVCo) strings** into structured data with **CRC validation**, making it safe to use for payment applications, PPOB systems, e-wallets, and backend validation services.

This package is designed for developers working with QRIS and digital payment systems, especially in Indonesia.

---

## Features

- Parse QRIS strings into structured data
- EMVCo-compliant CRC validation
- Supports static and dynamic QRIS
- Compatible with Flutter and Dart backend
- Lightweight with no heavy dependencies
- Easy integration with PPOB and payment flows

---

## Why This Package?

QRIS uses the **EMVCo TLV** format which is:
- Long and hard to read manually
- Error-prone when parsed incorrectly
- Required to be CRC-validated before processing

This package helps:
- Reduce QRIS parsing complexity
- Prevent payment-related bugs
- Safely validate QRIS before sending to a payment gateways

---

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  qris_parser: ^1.0.1
```

Then run:

```bash
flutter pub get
```

---

## Usage

### Basic Parsing

```dart
import 'package:qris_parser/qris_parser.dart';

void main() {
  final qrisString = '00020101021226610016ID.CO.QRIS.WWW...';

  final result = QrisParser.parse(qrisString);

  if (result.isValid) {
    print('Merchant Name : ${result.merchantName}');
    print('Merchant City : ${result.merchantCity}');
    print('Amount        : ${result.amount}');
    print('CRC Valid     : ${result.isCrcValid}');
  } else {
    print('Invalid QRIS');
  }
}
```

---

## Parsed Data Example

```json
{
  "merchantName": "TOKO MAJU JAYA",
  "merchantCity": "JAKARTA",
  "merchantCategoryCode": "5411",
  "transactionAmount": 10000,
  "countryCode": "ID",
  "currency": "IDR",
  "crcValid": true
}
```

---

## Parsed Fields

| Field | Description |
|------|------------|
| Merchant Name | Merchant name |
| Merchant City | Merchant city |
| MCC | Merchant Category Code |
| Transaction Amount | Payment amount |
| Country Code | Country code |
| Currency | Currency |
| CRC | Checksum validation |

---

## CRC Validation

CRC validation is performed automatically during parsing.

```dart
if (result.isCrcValid) {
  // QRIS is valid and safe to process
}
```

---

## Use Cases

- PPOB applications
- QRIS payment gateways
- Backend validation services
- QRIS scanner applications
- Payment simulators
- Fraud prevention systems

---

## Notes

- This package does not perform payments
- It only parses and validates QRIS structures
- Always comply with local regulations and payment gateway requirements

---

## Roadmap

- Support for QRIS CPM
- Custom EMV tag support
- Detailed error handling and debug mode
- Go and Node.js versions
- QRIS payment simulator

---

## Contributing

Contributions are welcome.

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Open a Pull Request

---

## License

MIT License  
Free to use for personal and commercial projects.

---

---

# Dokumentasi Bahasa Indonesia

QRIS Parser adalah package Dart untuk mem-parsing string QRIS (EMVCo) menjadi data terstruktur dengan validasi CRC, sehingga aman digunakan untuk aplikasi payment, PPOB, e-wallet, dan backend validation.

---

## Fitur

- Parsing QRIS ke struktur data
- Validasi CRC sesuai standar EMVCo
- Mendukung QRIS statis dan dinamis
- Kompatibel dengan Flutter dan backend Dart
- Ringan tanpa dependency berat
- Mudah diintegrasikan ke sistem PPOB

---

## Instalasi

Tambahkan ke `pubspec.yaml`:

```yaml
dependencies:
  qris_parser: ^1.0.1
```

Kemudian jalankan:

```bash
flutter pub get
```

---

## Contoh Penggunaan

```dart
final result = QrisParser.parse(qrisString);

if (result.isValid) {
  print(result.merchantName);
}
```

---

## Catatan

- Package ini tidak melakukan proses pembayaran
- Hanya parsing dan validasi struktur QRIS
- Pastikan mematuhi regulasi Bank Indonesia dan payment gateway terkait
