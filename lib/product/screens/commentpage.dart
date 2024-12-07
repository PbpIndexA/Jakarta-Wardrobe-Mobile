import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jawa_app/product/models/model.dart';
import 'package:jawa_app/shared/models/sharedmodel.dart'; // Ensure ProductEntry model is available

class CommentPage extends StatefulWidget {
  final ProductEntry product;

  const CommentPage({super.key, required this.product});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _comments = []; // List to store comments

  @override
  void initState() {
    super.initState();
    loadComments(); // Memuat komentar saat halaman pertama kali dibuka
  }

  // Fungsi untuk memuat komentar dari server
  Future<void> loadComments() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/get_comments/${widget.product.uuid}/'),  // Endpoint untuk mengambil komentar
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _comments.clear();
        for (var commentJson in data['comments']) {
          _comments.add(Comment.fromJson(commentJson));  // Mengubah data JSON menjadi objek Comment
        }
      });
    } else {
      print('Failed to load comments');
    }
  }

  // Fungsi untuk menambahkan komentar
  Future<void> addCommentToProduct(String commentText, String token) async {
    final url = Uri.parse('http://127.0.0.1:8000/products/review_products');  // Endpoint untuk menambahkan komentar
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',  // Jika menggunakan autentikasi dengan token
    };

    final body = json.encode({
      'product_id': widget.product.uuid,
      'comment': commentText,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('Comment added successfully: ${responseBody["message"]}');
      loadComments();  // Muat ulang komentar setelah berhasil menambah komentar baru
    } else {
      print('Failed to add comment: ${response.body}');
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
          // Background Container for Scrollable Comments
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 350), // Adjust for the new image height
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comments List
                  ListView.builder(
                    shrinkWrap: true, // Avoid overflow issues
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return CommentCard(comment: comment.comment);
                    },
                  ),

                  // Comment Input Field
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

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      final commentText = _commentController.text;
                      if (commentText.isNotEmpty) {
                        // Misalnya gunakan token hardcode atau token dari penyimpanan
                        String token = "your_auth_token";  // Ganti dengan token yang sebenarnya
                        addCommentToProduct(commentText, token);
                        _commentController.clear(); // Clear input after submitting
                      }
                    },
                    child: const Text("Submit Comment"),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Image at the Top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.product.imgUrl,
                height: 350, // Set the height of the image to 350
                width: MediaQuery.of(context).size.width, // Full-width image
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / 
                            (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 350); // Fallback icon if image fails to load
                },
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          comment,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
