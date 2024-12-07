class Comment {
  final String uuid;
  final String productId;
  final String user;
  final String comment;
  final String timestamp;

  Comment({
    required this.uuid,
    required this.productId,
    required this.user,
    required this.comment,
    required this.timestamp,
  });

  // Untuk membuat objek Comment dari JSON response
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      uuid: json['uuid'],
      productId: json['product_id'],
      user: json['user'],
      comment: json['comment'],
      timestamp: json['timestamp'],
    );
  }

  // Untuk mengubah objek Comment menjadi JSON ketika mengirim data ke server
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'product_id': productId,
      'user': user,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}
