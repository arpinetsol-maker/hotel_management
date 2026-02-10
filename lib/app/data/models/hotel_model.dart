class HotelModel {
  final String id;
  final String ownerId;
  final String? registrationRequestId;
  final String name;
  final String description;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final int? starRating;
  final double rating;
  final List<String> imagePaths;
  final List<String> amenities;
  final double pricePerNight;
  final int totalRooms;
  final bool isApproved;
  final bool isActive;
  final String? approvedBy;
  final DateTime? approvedAt;
  final bool isVisible;
  final DateTime createdAt;
  final DateTime updatedAt;

  HotelModel({
    required this.id,
    required this.ownerId,
    this.registrationRequestId,
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.starRating,
    required this.rating,
    required this.imagePaths,
    required this.amenities,
    required this.pricePerNight,
    required this.totalRooms,
    required this.isApproved,
    required this.isActive,
    this.approvedBy,
    this.approvedAt,
    required this.isVisible,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      registrationRequestId: json['registration_request_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String? ?? 'India',
      postalCode: json['postal_code'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      starRating: json['star_rating'] as int?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imagePaths: (json['image_paths'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      pricePerNight: (json['price_per_night'] as num).toDouble(),
      totalRooms: json['total_rooms'] as int,
      isApproved: json['is_approved'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'] as String)
          : null,
      isVisible: json['is_visible'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'registration_request_id': registrationRequestId,
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'star_rating': starRating,
      'rating': rating,
      'image_paths': imagePaths,
      'amenities': amenities,
      'price_per_night': pricePerNight,
      'total_rooms': totalRooms,
      'is_approved': isApproved,
      'is_active': isActive,
      'approved_by': approvedBy,
      'approved_at': approvedAt?.toIso8601String(),
      'is_visible': isVisible,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  HotelModel copyWith({
    String? id,
    String? ownerId,
    String? registrationRequestId,
    String? name,
    String? description,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? latitude,
    double? longitude,
    int? starRating,
    double? rating,
    List<String>? imagePaths,
    List<String>? amenities,
    double? pricePerNight,
    int? totalRooms,
    bool? isApproved,
    bool? isActive,
    String? approvedBy,
    DateTime? approvedAt,
    bool? isVisible,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HotelModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      registrationRequestId: registrationRequestId ?? this.registrationRequestId,
      name: name ?? this.name,
      description: description ?? this.description,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      starRating: starRating ?? this.starRating,
      rating: rating ?? this.rating,
      imagePaths: imagePaths ?? this.imagePaths,
      amenities: amenities ?? this.amenities,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      totalRooms: totalRooms ?? this.totalRooms,
      isApproved: isApproved ?? this.isApproved,
      isActive: isActive ?? this.isActive,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      isVisible: isVisible ?? this.isVisible,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}