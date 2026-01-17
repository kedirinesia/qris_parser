import 'package:qris_parser/qris_parser.dart';
import 'package:qris_parser/src/crc16.dart'; // Import to use calculate helper
import 'package:test/test.dart';

void main() {
  group('Qris Parser Tests', () {
    test('Parses valid QRIS string', () {
      final validQris = '0002010102115903ABC63041D84';
      final qris = Qris.parse(validQris);
      
      expect(qris.payloadFormatIndicator, '01');
      expect(qris.pointOfInitiationMethod, '11');
      expect(qris.merchantName, 'ABC');
      expect(qris.crc, '1D84');
    });

    test('Parses user provided real QRIS string', () {
      final realQris = '00020101021126570011ID.DANA.WWW011893600915387258349102098725834910303UMI51440014ID.CO.QRIS.WWW0215ID10253905048490303UMI5204481453033605802ID5912Fulung Store6014Kota Palembang61053011163047279';
      final qris = Qris.parse(realQris);

      expect(qris.merchantName, 'Fulung Store');
      expect(qris.merchantCity, 'Kota Palembang');
      expect(qris.postalCode, '30111');
      expect(qris.transactionCurrency, '360');
      expect(qris.merchantCategoryCode, '4814');
      expect(qris.crc, '7279');
    });

    test('CRC16 Calculation', () {
      // Standard Check for CRC-CCITT (0xFFFF)
      // ASCII "123456789" checksum is 0x29B1
      // final data = "123456789"; 
      // This test block was meant to test CRC logic but we can rely on integration tests above.
      // But let's keep the test meaningful or remove it.
      // Let's actually verify the helper if we can access it or just verify via public API as we did.
      // Since Crc16 is internal (src), we can test it because we are in test/ which can import src/
      
       expect(Crc16.calculate("123456789"), "29B1");
    });

    test('Throws InvalidCrcError on bad CRC', () {
      // 00020163040000 -> CRC is definitely not 0000
       expect(() => Qris.parse('00020163040000'), throwsA(isA<InvalidCrcError>()));
    });
    
    test('Throws InvalidFormatError on short data', () {
      expect(() => Qris.parse('00'), throwsA(isA<InvalidFormatError>()));
    });
    
     test('Throws InvalidFormatError on bad TLV', () {
       // Tag 00 length 99 but string ends
       // Base: 0099016304 (Length 99, Tag 63 Len 04)
       // We need valid CRC for "009901" + "6304"
       // Let's use Qris.parse on something that has VALID CRC but INVALID TLV.
       // "009901" -> CRC calc needed.
       // Instead of calculating, let's use a simpler invalid case that might pass CRC? No, CRC is strictly checked.
       
       // Let's manually append valid CRC for test string "0099016304"
       final dataNoCrc = "0099016304";
       final crc = Crc16.calculate(dataNoCrc);
       final fullData = dataNoCrc + crc;
       
      expect(() => Qris.parse(fullData), throwsA(isA<InvalidFormatError>()));
    });

  });
}

// Access to private static method not possible, so we duplicate calculate logic or use reflection?
// Or we just import Crc16 from src/crc16.dart as it's available in test folder (test can import from lib/src)

