class SubscriptionPlanModel {
  final String id;
  final String name;
  final String price;
  final String duration;
  final List<String> benefits;
  final bool isPopular;
  final String? badge;

  const SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.benefits,
    this.isPopular = false,
    this.badge,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: json['price'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isPopular: json['isPopular'] as bool? ?? false,
      badge: json['badge'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration': duration,
      'benefits': benefits,
      'isPopular': isPopular,
      'badge': badge,
    };
  }
}
