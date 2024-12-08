import 'dart:convert';
import 'package:http/http.dart' as http;

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

  // Membuat objek Comment dari JSON response
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      uuid: json['uuid'],
      productId: json['product'],
      user: json['user'],
      comment: json['comment'],
      timestamp: json['timestamp'],
    );
  }

  // Fungsi untuk mendapatkan daftar komentar dari API
  static Future<List<Comment>> fetchComments() async {
    final response = await http.get(Uri.parse('http://your-django-api-url/comments/'));

    if (response.statusCode == 200) {
      // Jika server mengembalikan response OK, kita parse data JSON
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((comment) => Comment.fromJson(comment)).toList();
    } else {
      // Jika gagal, throw exception
      throw Exception('Failed to load comments');
    }
  }
}
