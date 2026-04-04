class ChefProfileModel {
  final String name;
  final String email;
  final String image;
  final String about;
  final int experience;
  final double pricing;
  final String address;
  final double? lat;
  final double? lng;
  final double cookingAreaDistance;
  final double minimumBookingDuration;
  final bool orderAutoAccept;
  final bool weekDaysDiscountHas;
  final String weekDaysDiscountFrom;
  final String weekDaysDiscountTo;
  final double weekDaysDiscountRate;
  final bool weekendDiscountHas;
  final double weekendDiscountAmount;
  final List<String> foods;
  final String? stripeLoginLink;
  final bool notificationEnabled;

  ChefProfileModel({
    required this.name,
    required this.email,
    required this.image,
    this.about = '',
    this.experience = 0,
    this.pricing = 0,
    this.address = '',
    this.lat,
    this.lng,
    this.cookingAreaDistance = 10,
    this.minimumBookingDuration = 1,
    this.orderAutoAccept = false,
    this.weekDaysDiscountHas = false,
    this.weekDaysDiscountFrom = '',
    this.weekDaysDiscountTo = '',
    this.weekDaysDiscountRate = 0,
    this.weekendDiscountHas = false,
    this.weekendDiscountAmount = 0,
    this.foods = const [],
    this.stripeLoginLink,
    this.notificationEnabled = false,
  });

  factory ChefProfileModel.fromJson(Map<String, dynamic> json) {
    final location = json['cooking_area'] as Map<String, dynamic>?;
    final weekDiscount = json['week_days_discount'] as Map<String, dynamic>?;

    return ChefProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      about: json['about'] ?? '',
      experience: (json['experience'] ?? 0).toInt(),
      pricing: (json['pricing'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      lat: location != null ? (location['latitude'] as num?)?.toDouble() : null,
      lng: location != null ? (location['longitude'] as num?)?.toDouble() : null,
      cookingAreaDistance: (json['cooking_area_distance'] ?? 10).toDouble(),
      minimumBookingDuration: (json['minimum_short_order_hours'] ?? 1).toDouble(),
      orderAutoAccept: json['order_auto_accept'] ?? false,
      weekDaysDiscountHas: json['week_days_discount_has'] ?? false,
      weekDaysDiscountFrom: weekDiscount?['start_time'] ?? '',
      weekDaysDiscountTo: weekDiscount?['end_time'] ?? '',
      weekDaysDiscountRate: (weekDiscount?['amount'] ?? 0).toDouble(),
      weekendDiscountHas: json['weekend_discount_has'] ?? false,
      weekendDiscountAmount: (json['weekend_discount_amount'] ?? 0).toDouble(),
      foods: (json['foods'] as List?)
          ?.expand((e) => e.toString().split(','))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList() ?? [],
      stripeLoginLink: json['stripe_login_link'],
      notificationEnabled: json['notification_enabled'] ?? false,
    );
  }
}
