class RatingModel {
  final double rate;
  final int count;

  RatingModel({required this.rate, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: json['rate']?.toDouble() ?? 0.0,
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }
}
