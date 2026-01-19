class CustomerModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String address;

  CustomerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  CustomerModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
