# QRIS Parser (Dart / Flutter)

**QRIS Parser** adalah package Dart untuk mem-parsing string QRIS (EMVCo) menjadi data terstruktur, lengkap dengan validasi CRC, sehingga aman digunakan untuk aplikasi payment, PPOB, e-wallet, dan backend validation.

Package ini dibuat khusus untuk developer Indonesia yang berurusan dengan QRIS, payment gateway, dan sistem pembayaran digital.

---

## Features

- Parse QRIS string ke struktur data
- Validasi CRC (EMVCo compliant)
- Support QRIS statis dan dinamis
- Compatible dengan Flutter dan Dart backend
- Lightweight dan tanpa dependency berat
- Mudah diintegrasikan ke PPOB dan payment flow

---

## Why This Package?

QRIS menggunakan format EMVCo TLV yang:
- Panjang dan sulit dibaca secara manual
- Rentan error parsing
- Wajib divalidasi CRC sebelum diproses

Package ini dibuat untuk:
- Menghemat waktu parsing QRIS
- Menghindari bug pembayaran
- Mempermudah validasi QR sebelum diproses ke payment gateway

---

## Installation

Tambahkan ke `pubspec.yaml`:

```yaml
dependencies:
  qris_parser: ^1.0.0
```

Lalu jalankan:

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
| Merchant Name | Nama merchant |
| Merchant City | Kota merchant |
| MCC | Merchant Category Code |
| Transaction Amount | Nominal pembayaran |
| Country Code | ID |
| Currency | IDR |
| CRC | Validasi checksum |

---

## CRC Validation

Validasi CRC dilakukan otomatis saat parsing.

```dart
if (result.isCrcValid) {
  // QRIS valid dan aman diproses
}
```

---

## Use Cases

- PPOB App
- QRIS Payment Gateway
- Backend validation service
- QRIS scanner app
- Payment simulator
- Fraud prevention

---

## Notes

- Package ini tidak melakukan pembayaran
- Hanya parsing dan validasi struktur QRIS
- Pastikan tetap mengikuti regulasi BI dan payment gateway masing-masing

---

## Roadmap

- Support QRIS CPM
- Support custom EMV tag
- Error detail dan debug mode
- Go dan Node.js version
- QRIS simulator

---

## Contributing

Contributions are welcome.

1. Fork repository
2. Create feature branch
3. Commit changes
4. Open Pull Request

---

## License

MIT License  
Free to use for personal and commercial projects.

---

## Support

Jika package ini membantu:
- Beri star di GitHub
- Laporkan bug via Issues
- Kirim ide atau improvement
