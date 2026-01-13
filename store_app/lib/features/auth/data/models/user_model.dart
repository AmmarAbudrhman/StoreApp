class UserModel {
  final String email;
  final String fullName;
  final String phone;
  final String address;
  final String? imageUrl;
  final String? token;

  UserModel({
    required this.email,
    required this.fullName,
    required this.phone,
    required this.address,
    this.imageUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'imageUrl': imageUrl,
      'token': token,
    };
  }

  UserModel copyWith({
    String? email,
    String? fullName,
    String? phone,
    String? address,
    String? imageUrl,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      token: token ?? this.token,
    );
  }
}
