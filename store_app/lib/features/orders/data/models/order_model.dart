import 'package:store_app/features/orders/data/models/order_item_model.dart';

class OrderModel {
  final int id;
  final DateTime orderDate;
  final double totalAmount;
  final int customerId;
  final String customerName;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderDate,
    required this.totalAmount,
    required this.customerId,
    required this.customerName,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      orderDate: json['orderDate'] != null
          ? DateTime.tryParse(json['orderDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      totalAmount: json['totalAmount'] is num
          ? (json['totalAmount'] as num).toDouble()
          : double.tryParse(json['totalAmount'].toString()) ?? 0.0,
      customerId: json['customerId'] is int
          ? json['customerId']
          : int.tryParse(json['customerId'].toString()) ?? 0,
      customerName: json['customerName']?.toString() ?? '',
      items: json['items'] is List
          ? (json['items'] as List<dynamic>)
                .map(
                  (item) =>
                      OrderItemModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': totalAmount,
      'customerId': customerId,
      'customerName': customerName,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // For creating new orders
  Map<String, dynamic> toCreateJson() {
    return {
      'customerId': customerId,
      'items': items.map((item) => item.toCreateJson()).toList(),
    };
  }

  OrderModel copyWith({
    int? id,
    DateTime? orderDate,
    double? totalAmount,
    int? customerId,
    String? customerName,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      items: items ?? this.items,
    );
  }
}
