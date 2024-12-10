import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jawa_app/product/models/modelkomen.dart'; // Pastikan model komen ada
import 'package:jawa_app/product/models/sharedmodel.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart'; // Pastikan model ProductEntry tersedia

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
    final request = Provider.of<CookieRequest>(context, listen: false);
    loadComments(request); // Memuat komentar saat halaman dibuka
  }

Future<void> loadComments(CookieRequest request) async {
  final productId = widget.product.uuid;  // Ambil product_id dari widget
  final response = await request.get('http://127.0.0.1:8000/products/products/$productId/comments/');

  // Periksa apakah response sudah dalam format yang benar
    if (response['comments'] != null) {
      final data = response['comments']; // Akses langsung ke list komentar
      setState(() {
        _comments.clear(); // Bersihkan komentar sebelumnya

        // Tambahkan semua komentar ke dalam _comments
        for (var commentJson in data) {
          _comments.add(Comment.fromJson(commentJson));
        }
      });
    } else {
      print('Failed to load comments: Unexpected response format');
    }
}

  // Fungsi untuk menambahkan komentar tanpa token
  Future<void> addCommentToProduct(
      String commentText, CookieRequest request) async {
    final body = {
      'product_id': widget.product.uuid, // The product UUID
      'comment': commentText, // The comment text
    };
    try {
      // Sending the POST request
      final response = await request.post(
          'http://127.0.0.1:8000/products/add_comment/', body);

      // Checking the response status
      if (response['message'] == 'Comment added successfully') {
        loadComments(request); // Reload comments after adding a new one
      } else {
      }
    } catch (e) {
    }
  }

@override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
  const String defaultImageUrl =
      'https://thenblank.com/cdn/shop/products/MenBermudaPants_Fern_2_360x.jpg?v=1665997444'; // Default image URL

  return Scaffold(
    appBar: AppBar(
      title: const Text("Product Comments"),
    ),
    body: Column(
      children: [
        // Gambar Produk
        ClipRRect(
          child: Image.network(
            widget.product.imgUrl.isNotEmpty
                ? widget.product.imgUrl
                : defaultImageUrl,
            height: 200, // Sesuaikan tinggi gambar
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                defaultImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        const SizedBox(height: 8.0),

        // Judul Komentar
        Container(
          width: double.infinity,
          color: Colors.grey[200], // Background abu-abu untuk judul
          padding: const EdgeInsets.all(12.0),
          child: const Text(
            "Komentar",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),

        // List Komentar
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return CommentCard(comment: comment);
                    },
                  ),
                  const SizedBox(height: 16.0),

                ],
              ),
            ),
          ),
        ),
// Bagian Fixed di Bawah
Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  child: Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    child: Row(
      children: [
        // TextField untuk komentar
        Expanded(
          child: TextField(
            controller: _commentController,
            maxLines: 1, // Hanya satu baris
            decoration: InputDecoration(
              hintText: "Write a comment...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0), // Membulatkan sudut
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ), // Padding dalam text field
            ),
          ),
        ),
        const SizedBox(width: 8.0),

        // Tombol Submit
        GestureDetector(
          onTap: () {
            final commentText = _commentController.text;
            if (commentText.isNotEmpty) {
              addCommentToProduct(commentText, request);
              _commentController.clear(); // Bersihkan input
            }
          },
          child: CircleAvatar(
            radius: 24.0,
            backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Warna background tombol
            child: const Icon(
              Icons.send, // Ikon "send" seperti WhatsApp
              color: Colors.white, // Warna ikon
            ),
          ),
        ),
      ],
    ),
  ),
),
      ],
    ),
  );
}
}
class CommentCard extends StatelessWidget {
  final Comment comment; // Objek Comment

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama user di-bold
              Text(
                "${comment.user} ", // User diikuti spasi
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              // Isi komentar di baris yang sama
              Expanded(
                child: Text(
                  comment.comment,
                  style: const TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis, // Tambahkan ini jika komentar terlalu panjang
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),

          // Waktu komentar di bawahnya
          Text(
            comment.timestamp,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
          const Divider(), // Garis bawah untuk pemisah
        ],
      ),
    );
  }
}
class Comment {
  final String user;
  final String comment;
  final String timestamp;

  Comment({
    required this.user,
    required this.comment,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'],
      comment: json['comment'],
      timestamp: json['timestamp'],
    );
  }

  @override
  String toString() {
    return 'Comment(user: $user, comment: $comment, timestamp: $timestamp)';
  }
}
