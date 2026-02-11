class HotelRegistrationRequestModel {
  final String id;
  final String hotelAdminId;
  final String hotelName;
  final String hotelEmail;
  final String hotelPhone;
  final String address;
  final String city;
  final String state;
  final String country;
  final String? postalCode;
  final String? businessLicensePath;
  final String? taxId;
  final String? ownerIdProofPath;
  final String? description;
  final int totalRooms;
  final int? starRating;
  final String status; // 'pending', 'approved', 'rejected'
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? hotelImagePath;
  final String? hotelWebsite;

  HotelRegistrationRequestModel({
    required this.id,
    required this.hotelAdminId,
    required this.hotelName,
    required this.hotelEmail,
    required this.hotelPhone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    this.postalCode,
    this.businessLicensePath,
    this.taxId,
    this.ownerIdProofPath,
    this.description,
    required this.totalRooms,
    this.starRating,
    required this.status,
    this.reviewedBy,
    required this.reviewedAt,
    this.rejectionReason,
    this.adminNotes,
    required this.createdAt,
    required this.updatedAt,
    this.hotelImagePath,
    this.hotelWebsite
  });

  factory HotelRegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    return HotelRegistrationRequestModel(
      id: json['id'] as String,
      hotelAdminId: json['hotel_admin_id'] as String,
      hotelName: json['hotel_name'] as String,
      hotelEmail: json['hotel_email'] as String,
      hotelPhone: json['hotel_phone'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String? ?? 'India',
      postalCode: json['postal_code'] as String?,
      businessLicensePath: json['business_license_path'] as String?,
      taxId: json['tax_id'] as String?,
      ownerIdProofPath: json['owner_id_proof_path'] as String?,
      description: json['description'] as String?,
      totalRooms: json['total_rooms'] as int,
      starRating: json['star_rating'] as int?,
      status: json['status'] as String,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'])
          : null,
      rejectionReason: json['rejection_reason'] as String?,
      adminNotes: json['admin_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      hotelImagePath: json['hotel_image_path'],
      hotelWebsite: json['hotel_website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_admin_id': hotelAdminId,
      'hotel_name': hotelName,
      'hotel_email': hotelEmail,
      'hotel_phone': hotelPhone,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'business_license_path': businessLicensePath,
      'tax_id': taxId,
      'owner_id_proof_path': ownerIdProofPath,
      'description': description,
      'total_rooms': totalRooms,
      'star_rating': starRating,
      'status': status,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'admin_notes': adminNotes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'hotel_image_path': hotelImagePath,
      'hotel_website': hotelWebsite,
    };
  }
}