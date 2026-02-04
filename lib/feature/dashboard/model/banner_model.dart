
class BannerModel {
  final int id;
  final String imageUrl;
  final String defaultImageUrl;
  final String title;
  final String subtitle;
  final String bannerType;
  final String clickType;
  final List<int> targetId;
  final int priority;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.defaultImageUrl,
    required this.title,
    required this.subtitle,
    required this.bannerType,
    required this.clickType,
    required this.targetId,
    required this.priority,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,

      imageUrl: json['image_url'] ?? '',
      defaultImageUrl: json['default_image_url'] ?? '',

      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',

      bannerType: json['banner_type'] ?? '',
      clickType: json['click_type'] ?? '',

      targetId: json['target_id'] != null
          ? List<int>.from(json['target_id'])
          : [],
      priority: json['priority'] ?? 0,

      isActive: json['is_active'] ?? false,

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'default_image_url': defaultImageUrl,
      'title': title,
      'subtitle': subtitle,
      'banner_type': bannerType,
      'click_type': clickType,
      'target_id': targetId,
      'priority': priority,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
