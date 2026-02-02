class HomeSection {
  final int id;
  final String sectionName;
  final String displayName;
  final int displayOrder;
  final String uiStyle;
  final bool isVisible;
  final DateTime createdAt;
  final DateTime updatedAt;

  HomeSection({
    required this.id,
    required this.sectionName,
    required this.displayName,
    required this.displayOrder,
    required this.uiStyle,
    required this.isVisible,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    return HomeSection(
      id: json['id'],
      sectionName: json['section_name'],
      displayName: json['display_name'],
      displayOrder: json['display_order'],
      uiStyle: json['ui_style'],
      isVisible: json['is_visible'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
