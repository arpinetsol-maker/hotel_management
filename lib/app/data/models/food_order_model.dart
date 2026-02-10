class FoodOrderModel {
  final String id;
  final String userId;
  final String hotelId;
  final String? bookingId;
  final Map<String, dynamic> items; // JSON with menu items
  final String? roomNumber;
  final String? deliveryInstructions;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double totalAmount;
  final String status; // 'pending', 'preparing', 'ready', 'delivered', 'cancelled'
  final String paymentStatus; // 'pending', 'paid', 'refunded'
  final DateTime orderedAt;
  final DateTime? estimatedDeliveryTime;
  final DateTime? deliveredAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  FoodOrderModel({
    required this.id,
    required this.userId,
    required this.hotelId,
    this.bookingId,
    required this.items,
    this.roomNumber,
    this.deliveryInstructions,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.orderedAt,
    this.estimatedDeliveryTime,
    this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodOrderModel.fromJson(Map<String, dynamic> json) {
    return FoodOrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      hotelId: json['hotel_id'] as String,
      bookingId: json['booking_id'] as String?,
      items: json['items'] as Map<String, dynamic>,
      roomNumber: json['room_number'] as String?,
      deliveryInstructions: json['delivery_instructions'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      orderedAt: DateTime.parse(json['ordered_at'] as String),
      estimatedDeliveryTime: json['estimated_delivery_time'] != null
          ? DateTime.parse(json['estimated_delivery_time'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'hotel_id': hotelId,
      'booking_id': bookingId,
      'items': items,
      'room_number': roomNumber,
      'delivery_instructions': deliveryInstructions,
      'subtotal': subtotal,
      'tax': tax,
      'delivery_fee': deliveryFee,
      'total_amount': totalAmount,
      'status': status,
      'payment_status': paymentStatus,
      'ordered_at': orderedAt.toIso8601String(),
      'estimated_delivery_time': estimatedDeliveryTime?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}