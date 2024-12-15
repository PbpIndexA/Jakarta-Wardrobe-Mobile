class Article {
  final String uuid;
  final String title;
  final String user; // Username dari user yang login
  final String content;
  final String imageUrl;
  final String timestamp;

  Article({
    required this.uuid,
    required this.title,
    required this.user,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      uuid: json['uuid'],
      title: json['title'],
      user: json['user'],
      content: json['content'],
      imageUrl: json['image_url'],
      timestamp: json['timestamp'],
    );
  }
}
