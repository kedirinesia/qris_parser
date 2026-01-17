import 'crc16.dart';
import 'errors.dart';

/// Represents a parsed QRIS code.
class Qris {
  final String rawData;
  final String payloadFormatIndicator; // 00
  final String pointOfInitiationMethod; // 01
  final Map<int, MerchantAccountInformation> merchantAccountInformation; // 02-51
  final String? merchantCategoryCode; // 52
  final String? transactionCurrency; // 53
  final String? transactionAmount; // 54
  final String? tipOrConvenienceIndicator; // 55
  final String? valueOfConvenienceFeeFixed; // 56
  final String? valueOfConvenienceFeePercentage; // 57
  final String? countryCode; // 58
  final String? merchantName; // 59
  final String? merchantCity; // 60
  final String? postalCode; // 61
  final AdditionalDataField? additionalDataField; // 62
  final String crc; // 63

  Qris({
    required this.rawData,
    required this.payloadFormatIndicator,
    required this.pointOfInitiationMethod,
    required this.merchantAccountInformation,
    this.merchantCategoryCode,
    this.transactionCurrency,
    this.transactionAmount,
    this.tipOrConvenienceIndicator,
    this.valueOfConvenienceFeeFixed,
    this.valueOfConvenienceFeePercentage,
    this.countryCode,
    this.merchantName,
    this.merchantCity,
    this.postalCode,
    this.additionalDataField,
    required this.crc,
  });

  /// Parses a QRIS string into a [Qris] object.
  /// 
  /// Throws [InvalidFormatError] if the format is invalid.
  /// Throws [InvalidCrcError] if the CRC checksum fails.
  factory Qris.parse(String rawData) {
    Crc16.validate(rawData);

    final Map<int, String> rootTags = _parseTlv(rawData);

    return Qris(
      rawData: rawData,
      payloadFormatIndicator: rootTags[00] ?? '',
      pointOfInitiationMethod: rootTags[01] ?? '',
      merchantAccountInformation: _parseMerchantAccounts(rootTags),
      merchantCategoryCode: rootTags[52],
      transactionCurrency: rootTags[53],
      transactionAmount: rootTags[54],
      tipOrConvenienceIndicator: rootTags[55],
      valueOfConvenienceFeeFixed: rootTags[56],
      valueOfConvenienceFeePercentage: rootTags[57],
      countryCode: rootTags[58],
      merchantName: rootTags[59],
      merchantCity: rootTags[60],
      postalCode: rootTags[61],
      additionalDataField: rootTags.containsKey(62)
          ? AdditionalDataField.parse(rootTags[62]!)
          : null,
      crc: rootTags[63] ?? '',
    );
  }

  static Map<int, MerchantAccountInformation> _parseMerchantAccounts(
      Map<int, String> tags) {
    final result = <int, MerchantAccountInformation>{};
    for (int i = 2; i <= 51; i++) {
      if (tags.containsKey(i)) {
        result[i] = MerchantAccountInformation.parse(i, tags[i]!);
      }
    }
    return result;
  }
}

class MerchantAccountInformation {
  final int id;
  final String? globalUniqueId; // 00
  final String? pan; // 01
  final String? merchantId; // 02
  final String? criteria; // 03

  MerchantAccountInformation({
    required this.id,
    this.globalUniqueId,
    this.pan,
    this.merchantId,
    this.criteria,
  });

  factory MerchantAccountInformation.parse(int id, String data) {
    final tags = _parseTlv(data);
    return MerchantAccountInformation(
      id: id,
      globalUniqueId: tags[00],
      pan: tags[01],
      merchantId: tags[02],
      criteria: tags[03],
    );
  }
}

class AdditionalDataField {
  final String? billNumber; // 01
  final String? mobileNumber; // 02
  final String? storeLabel; // 03
  final String? loyaltyNumber; // 04
  final String? referenceLabel; // 05
  final String? customerLabel; // 06
  final String? terminalLabel; // 07
  final String? purposeOfTransaction; // 08
  final String? additionalConsumerDataRequest; // 09

  AdditionalDataField({
    this.billNumber,
    this.mobileNumber,
    this.storeLabel,
    this.loyaltyNumber,
    this.referenceLabel,
    this.customerLabel,
    this.terminalLabel,
    this.purposeOfTransaction,
    this.additionalConsumerDataRequest,
  });

  factory AdditionalDataField.parse(String data) {
    final tags = _parseTlv(data);
    return AdditionalDataField(
      billNumber: tags[01],
      mobileNumber: tags[02],
      storeLabel: tags[03],
      loyaltyNumber: tags[04],
      referenceLabel: tags[05],
      customerLabel: tags[06],
      terminalLabel: tags[07],
      purposeOfTransaction: tags[08],
      additionalConsumerDataRequest: tags[09],
    );
  }
}

/// Helper to parse TLV data.
Map<int, String> _parseTlv(String data) {
  final result = <int, String>{};
  int index = 0;
  while (index < data.length) {
    if (index + 4 > data.length) break;
    final tagId = int.tryParse(data.substring(index, index + 2));
    final length = int.tryParse(data.substring(index + 2, index + 4));

    if (tagId == null || length == null) {
      throw InvalidFormatError('Invalid tag or length at index $index');
    }

    index += 4;
    if (index + length > data.length) {
       throw InvalidFormatError('Data length mismatch for tag $tagId');
    }
    
    final value = data.substring(index, index + length);
    result[tagId] = value;
    index += length;
  }
  return result;
}
