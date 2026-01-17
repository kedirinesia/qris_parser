import 'errors.dart';

class Crc16 {
  static const int _polynomial = 0x1021; // CRC-CCITT (0xFFFF)

  static void validate(String qrisData) {
    if (qrisData.length < 4) {
      throw InvalidFormatError('Data too short to contain CRC');
    }

    final dataWithoutCrc = qrisData.substring(0, qrisData.length - 4);
    final providedCrc = qrisData.substring(qrisData.length - 4);

    final calculatedCrc = calculate(dataWithoutCrc);

    if (calculatedCrc.toUpperCase() != providedCrc.toUpperCase()) {
      throw InvalidCrcError(
          'Invalid CRC. Expected: $calculatedCrc, Found: $providedCrc');
    }
  }

  static String calculate(String data) {
    int crc = 0xFFFF;

    for (int i = 0; i < data.length; i++) {
      int byte = data.codeUnitAt(i) & 0xFF;
      crc ^= (byte << 8);
      for (int k = 0; k < 8; k++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ _polynomial;
        } else {
          crc <<= 1;
        }
      }
    }

    // Mask to 16-bit
    crc &= 0xFFFF;
    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }
}
