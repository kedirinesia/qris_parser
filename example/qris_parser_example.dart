import 'package:qris_parser/qris_parser.dart';

void main() {
  // Example valid QRIS string
  final qrisData = '00020101021126570011ID.DANA.WWW011893600915387258349102098725834910303UMI51440014ID.CO.QRIS.WWW0215ID10253905048490303UMI5204481453033605802ID5912Fulung Store6014Kota Palembang61053011163047279';

  try {
    final qris = Qris.parse(qrisData);
    print('Parsing successful!');
    print('Merchant Name: ${qris.merchantName}');
    print('CRC: ${qris.crc}');
  } on QrisError catch (e) {
    print('Error parsing QRIS: $e');
  }
}
