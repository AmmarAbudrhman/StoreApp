class OrderItemModel {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      productId: json['productId'] is int
          ? json['productId']
          : int.tryParse(json['productId'].toString()) ?? 0,
      productName: json['productName']?.toString() ?? '',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,
      unitPrice: json['unitPrice'] is num
          ? (json['unitPrice'] as num).toDouble()
          : double.tryParse(json['unitPrice'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  // For creating new orders (without id and productName)
  Map<String, dynamic> toCreateJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}
