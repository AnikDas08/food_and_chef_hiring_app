class ChefProfileModel {
  final String name;
  final String email;
  final String image;

  ChefProfileModel({
    required this.name,
    required this.email,
    required this.image,
  });

  factory ChefProfileModel.fromJson(Map<String, dynamic> json) {
    return ChefProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
    );
  }
}