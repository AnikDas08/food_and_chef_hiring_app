class ChefProfileModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String about;
  final String image;
  final String address;
  final int experience;
  final double avgRating;
  final int totalRating;
  final double pricing;
  final int cookingAreaDistance;
  final int minimumShortOrderHours;
  final bool isAccountSetupComplete;
  final bool isProfessionalChef;
  final bool orderAutoAccept;
  final bool verified;
  final String status;

  // Discount
  final bool weekDaysDiscountHas;
  final bool weekendDiscountHas;
  final double weekendDiscountAmount;
  final WeekDaysDiscount? weekDaysDiscount;

  // Documents
  final String proofOfAddress;
  final String foodSafetyCertificate;
  final String criminalBackgroundCheck;
  final String ssn;
  final List<String> additionalCulinaryLicenses;
  final IdCard idCard;

  // Verification Status
  final FoodSafetyCertificateStatus foodSafetyCertificateStatus;
  final NidVerificationStatus nidVerificationStatus;
  final SexOffenderCheckStatus sexOffenderCheckStatus;

  // Location
  final ChefLocation location;

  // Availability
  final List<AvailabilityDay> availability;

  // Others
  final List<String> cuisinesExpertise;
  final List<String> foods;
  final String stripeCustomerId;
  final String stripeAccountId;
  final String stripeLoginLink;
  final String stripePaymentMethodId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChefProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.about,
    required this.image,
    required this.address,
    required this.experience,
    required this.avgRating,
    required this.totalRating,
    required this.pricing,
    required this.cookingAreaDistance,
    required this.minimumShortOrderHours,
    required this.isAccountSetupComplete,
    required this.isProfessionalChef,
    required this.orderAutoAccept,
    required this.verified,
    required this.status,
    required this.weekDaysDiscountHas,
    required this.weekendDiscountHas,
    required this.weekendDiscountAmount,
    this.weekDaysDiscount,
    required this.proofOfAddress,
    required this.foodSafetyCertificate,
    required this.criminalBackgroundCheck,
    required this.ssn,
    required this.additionalCulinaryLicenses,
    required this.idCard,
    required this.foodSafetyCertificateStatus,
    required this.nidVerificationStatus,
    required this.sexOffenderCheckStatus,
    required this.location,
    required this.availability,
    required this.cuisinesExpertise,
    required this.foods,
    required this.stripeCustomerId,
    required this.stripeAccountId,
    required this.stripeLoginLink,
    required this.stripePaymentMethodId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChefProfileModel.fromJson(Map<String, dynamic> json) {
    return ChefProfileModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      about: json['about'] ?? '',
      image: json['image'] ?? '',
      address: json['address'] ?? '',
      experience: json['experience'] ?? 0,
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      totalRating: json['total_rating'] ?? 0,
      pricing: (json['pricing'] ?? 0).toDouble(),
      cookingAreaDistance: json['cooking_area_distance'] ?? 0,
      minimumShortOrderHours: json['minimum_short_order_hours'] ?? 0,
      isAccountSetupComplete: json['is_account_setup_complete'] ?? false,
      isProfessionalChef: json['is_professional_chef'] ?? false,
      orderAutoAccept: json['order_auto_accept'] ?? false,
      verified: json['verified'] ?? false,
      status: json['status'] ?? '',
      weekDaysDiscountHas: json['week_days_discount_has'] ?? false,
      weekendDiscountHas: json['weekend_discount_has'] ?? false,
      weekendDiscountAmount: (json['weekend_discount_amount'] ?? 0).toDouble(),
      weekDaysDiscount: json['week_days_discount'] != null
          ? WeekDaysDiscount.fromJson(json['week_days_discount'])
          : null,
      proofOfAddress: json['proof_of_address'] ?? '',
      foodSafetyCertificate: json['food_safety_certificate'] ?? '',
      criminalBackgroundCheck: json['criminal_background_check'] ?? '',
      ssn: json['ssn'] ?? '',
      additionalCulinaryLicenses:
      List<String>.from(json['additional_culinary_licenses'] ?? []),
      idCard: IdCard.fromJson(json['id_card'] ?? {}),
      foodSafetyCertificateStatus: FoodSafetyCertificateStatus.fromJson(
          json['food_safety_certificate_status'] ?? {}),
      nidVerificationStatus:
      NidVerificationStatus.fromJson(json['nid_verification_status'] ?? {}),
      sexOffenderCheckStatus:
      SexOffenderCheckStatus.fromJson(json['sex_offender_check_status'] ?? {}),
      location: ChefLocation.fromJson(json['location'] ?? {}),
      availability: (json['availability'] as List? ?? [])
          .map((e) => AvailabilityDay.fromJson(e))
          .toList(),
      cuisinesExpertise: List<String>.from(json['cousines_expertise'] ?? []),
      foods: List<String>.from(json['foods'] ?? []),
      stripeCustomerId: json['stripe_cus_id'] ?? '',
      stripeAccountId: json['stripe_account_id'] ?? '',
      stripeLoginLink: json['stripe_login_link'] ?? '',
      stripePaymentMethodId: json['stripe_payment_method_id'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

// ── Sub Models ──

class WeekDaysDiscount {
  final String startTime;
  final String endTime;
  final double amount;

  WeekDaysDiscount({required this.startTime, required this.endTime, required this.amount});

  factory WeekDaysDiscount.fromJson(Map<String, dynamic> json) => WeekDaysDiscount(
    startTime: json['start_time'] ?? '',
    endTime: json['end_time'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
  );
}

class IdCard {
  final String front;
  final String back;

  IdCard({required this.front, required this.back});

  factory IdCard.fromJson(Map<String, dynamic> json) => IdCard(
    front: json['front'] ?? '',
    back: json['back'] ?? '',
  );
}

class FoodSafetyCertificateStatus {
  final bool isValid;
  final String reason;

  FoodSafetyCertificateStatus({required this.isValid, required this.reason});

  factory FoodSafetyCertificateStatus.fromJson(Map<String, dynamic> json) =>
      FoodSafetyCertificateStatus(
        isValid: json['isValid'] ?? false,
        reason: json['reason'] ?? '',
      );
}

class NidVerificationStatus {
  final String status;
  final String reason;
  final List<String> warnings;

  NidVerificationStatus({required this.status, required this.reason, required this.warnings});

  factory NidVerificationStatus.fromJson(Map<String, dynamic> json) =>
      NidVerificationStatus(
        status: json['status'] ?? '',
        reason: json['reason'] ?? '',
        warnings: List<String>.from(json['warnings'] ?? []),
      );
}

class SexOffenderCheckStatus {
  final String status;
  final String reason;
  final String crime;
  final String offenderUrl;

  SexOffenderCheckStatus({
    required this.status,
    required this.reason,
    required this.crime,
    required this.offenderUrl,
  });

  factory SexOffenderCheckStatus.fromJson(Map<String, dynamic> json) =>
      SexOffenderCheckStatus(
        status: json['status'] ?? '',
        reason: json['reason'] ?? '',
        crime: json['crime'] ?? '',
        offenderUrl: json['offenderUrl'] ?? '',
      );
}

class ChefLocation {
  final String type;
  final double latitude;
  final double longitude;

  ChefLocation({required this.type, required this.latitude, required this.longitude});

  factory ChefLocation.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List? ?? [0, 0];
    return ChefLocation(
      type: json['type'] ?? 'Point',
      longitude: (coords[0] ?? 0).toDouble(),
      latitude: (coords[1] ?? 0).toDouble(),
    );
  }
}

class AvailabilityDay {
  final String day;
  final bool isAvailable;
  final List<AvailabilitySlot> slots;

  AvailabilityDay({required this.day, required this.isAvailable, required this.slots});

  factory AvailabilityDay.fromJson(Map<String, dynamic> json) => AvailabilityDay(
    day: json['day'] ?? '',
    isAvailable: json['availableity']?.toString() == 'true',
    slots: (json['availability_times'] as List? ?? [])
        .map((e) => AvailabilitySlot.fromJson(e))
        .toList(),
  );
}

class AvailabilitySlot {
  final String startTime;
  final String endTime;

  AvailabilitySlot({required this.startTime, required this.endTime});

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) => AvailabilitySlot(
    startTime: json['start_time'] ?? '',
    endTime: json['end_time'] ?? '',
  );
}