import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jawa_app/product/models/modelkomen.dart'; // Pastikan model komen ada
import 'package:jawa_app/shared/models/sharedmodel.dart'; // Pastikan model ProductEntry tersedia

class CommentPage extends StatefulWidget {
  final ProductEntry product;

  const CommentPage({super.key, required this.product});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _comments = []; // List untuk menyimpan komentar

  @override
  void initState() {
    super.initState();
    loadComments(); // Memuat komentar saat halaman dibuka
  }

  // Fungsi untuk memuat komentar dari server
  Future<void> loadComments() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/products/comments/'),  // Endpoint untuk fetch komentar
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _comments.clear();
        for (var commentJson in data['comments']) {
          _comments.add(Comment.fromJson(commentJson));  // Mengubah JSON menjadi objek Comment
        }
      });
    } else {
      print('Failed to load comments');
    }
  }

  // Fungsi untuk menambahkan komentar tanpa token
  Future<void> addCommentToProduct(String commentText) async {
    final url = Uri.parse('http://127.0.0.1:8000/products/products/add_comment_flutter/');  // Endpoint untuk menambahkan komentar
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'product_id': widget.product.uuid,
      'comment': commentText,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('Comment added successfully: ${responseBody["message"]}');
      loadComments();  // Reload comments after adding a new one
    } else {
      print('Failed to add comment: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Comments"),
      ),
      body: Stack(
        children: [
          // Container untuk komentar yang dapat discroll
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 350), // Sesuaikan padding untuk tinggi gambar
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // List Komentar
                  ListView.builder(
                    shrinkWrap: true, // Menghindari overflow
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return CommentCard(comment: comment.comment);
                    },
                  ),

                  // Input Field untuk komentar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                  ),

                  // Tombol Submit
                  ElevatedButton(
                    onPressed: () {
                      final commentText = _commentController.text;
                      if (commentText.isNotEmpty) {
                        addCommentToProduct(commentText); // Menambahkan komentar
                        _commentController.clear(); // Menghapus input setelah dikirim
                      }
                    },
                    child: const Text("Submit Comment"),
                  ),
                ],
              ),
            ),
          ),

          // Gambar Produk di bagian atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.product.imgUrl,
                height: 300,  // Sesuaikan tinggi dengan desain
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final String comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(comment),
      ),
    );
  }
}

class Comment {
  final String comment;

  Comment({required this.comment});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      comment: json['comment'],
    );
  }
}