class UserModel {
  final String email;
  final num? latitude;
  final num? longitude;

  const UserModel({
    required this.email,
    required this.latitude,
    required this.longitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
