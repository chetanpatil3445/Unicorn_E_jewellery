class StoryModel {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String mediaUrl;
  final String mediaType;
  final int duration;

  StoryModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.mediaUrl,
    required this.mediaType,
    required this.duration,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnail_url'],
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      duration: json['duration'],
    );
  }
}