import 'dart:convert';
import 'package:http/http.dart' as http;

class Comment {
  final String uuid;
  final String user;
  final String comment;
  final String timestamp;
  final bool isCurrentUser; // Tambahkan atribut ini

  Comment({
    required this.uuid,
    required this.user,
    required this.comment,
    required this.timestamp,
    required this.isCurrentUser,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      uuid: json['uuid'],
      user: json['user'],
      comment: json['comment'],
      timestamp: json['timestamp'],
      isCurrentUser: json['is_current_user']);// Gunakan nilai dari backend
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

    // Getter untuk nama user
  String get getUser => user;

  // Getter untuk timestamp
  String get getTimestamp => timestamp;

    @override
  String toString() {
    return 'Comment(user: $user, comment: $comment, timestamp: $timestamp)';
  }


}
