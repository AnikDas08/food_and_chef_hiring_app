// lib/features/address/model/address_model.dart

class AddressListResponse {
  final bool success;
  final String message;
  final PaginationModel pagination;
  final List<AddressModel> data;

  AddressListResponse({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory AddressListResponse.fromJson(Map<dynamic, dynamic> json) {
    return AddressListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List? ?? [])
          .map((e) => AddressModel.fromJson(e))
          .toList(),
    );
  }
}

class PaginationModel {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  PaginationModel({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPage: json['totalPage'] ?? 1,
    );
  }
}

class AddressModel {
  final String id;
  final String user;
  final String label;
  final String status;
  final bool isDefault;
  final String address;
  final String detailsAddress;
  final String additionalDetails;
  final String ownerName;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;

  AddressModel({
    required this.id,
    required this.user,
    required this.label,
    required this.status,
    required this.isDefault,
    required this.address,
    required this.detailsAddress,
    required this.additionalDetails,
    required this.ownerName,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      label: json['label'] ?? '',
      status: json['status'] ?? '',
      isDefault: json['is_default'] ?? false,
      address: json['address'] ?? '',
      detailsAddress: json['details_address'] ?? '',
      additionalDetails: json['additional_details'] ?? '',
      ownerName: json['owner_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user,
    'label': label,
    'status': status,
    'is_default': isDefault,
    'address': address,
    'details_address': detailsAddress,
    'additional_details': additionalDetails,
    'owner_name': ownerName,
    'phone_number': phoneNumber,
    'latitude': latitude,
    'longitude': longitude,
  };
}