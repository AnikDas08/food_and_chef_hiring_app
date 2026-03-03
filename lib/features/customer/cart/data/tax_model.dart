// lib/features/customer/cart/data/tax_model.dart

class TaxModel {
  final String id;
  final String organization;
  final String name;
  final String streetAddress;
  final String city;
  final String postalCode;
  final String taxId;
  final bool isDefault;

  TaxModel({
    required this.id,
    required this.organization,
    required this.name,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
    required this.taxId,
    required this.isDefault,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
    id: json['_id'] ?? '',
    organization: json['orgnaization'] ?? '',
    name: json['name'] ?? '',
    streetAddress: json['street_address'] ?? '',
    city: json['city'] ?? '',
    postalCode: json['postal_code'] ?? '',
    taxId: json['tax_id'] ?? '',
    isDefault: json['is_default'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'orgnaization': organization,
    'name': name,
    'street_address': streetAddress,
    'city': city,
    'postal_code': postalCode,
    'tax_id': taxId,
    'is_default': isDefault,
  };
}