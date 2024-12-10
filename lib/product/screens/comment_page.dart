import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jawa_app/product/models/modelkomen.dart';
import 'package:jawa_app/product/models/sharedmodel.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final ProductEntry product;

  const CommentPage({super.key, required this.product});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _comments = [];
  late String currentUser; // Nama user yang sedang login

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    currentUser = request.jsonData['username']; // Ambil nama user login
    loadComments(request);
  }

  Future<void> loadComments(CookieRequest request) async {
    final productId = widget.product.uuid;
    final response = await request.get(
      'http://127.0.0.1:8000/products/products/$productId/comments/',
    );

    if (response['comments'] != null) {
      final data = response['comments'];
      setState(() {
        _comments.clear();
        for (var commentJson in data) {
          _comments.add(Comment.fromJson(commentJson));
        }
        _comments.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      });
    } else {
      print('Failed to load comments: Unexpected response format');
    }
  }

  Future<void> addCommentToProduct(
      String commentText, CookieRequest request) async {
    final body = {
      'product_id': widget.product.uuid,
      'comment': commentText,
    };
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/products/add_comment/',
        body,
      );

      if (response['message'] == 'Comment added successfully') {
        loadComments(request);
      }
    } catch (e) {
      print("Error adding comment: $e");
    }
  }

Future<void> deleteComment(String commentId, CookieRequest request) async {
  try {
    final response = await request.post(
      'http://127.0.0.1:8000/products/comments/delete/$commentId/',
      {'comment_id': commentId},
    );

    if (response['message'] == 'Comment deleted successfully') {
      setState(() {
        _comments.removeWhere((comment) => comment.commentId == commentId);
      });
    } else {
      print("Failed to delete comment: ${response['message']}");
    }
  } catch (e) {
    print("Error deleting comment: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    const String defaultImageUrl =
        'https://thenblank.com/cdn/shop/products/MenBermudaPants_Fern_2_360x.jpg?v=1665997444';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Column(
        children: [
          ClipRRect(
            child: Image.network(
              widget.product.imgUrl.isNotEmpty
                  ? widget.product.imgUrl
                  : defaultImageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  defaultImageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.all(12.0),
            child: const Text(
              "Komentar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return CommentCard(
                  comment: comment,
                  currentUser: currentUser,
                  onDelete: (commentId) =>
                      deleteComment(commentId, request),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    final commentText = _commentController.text;
                    if (commentText.isNotEmpty) {
                      addCommentToProduct(commentText, request);
                      _commentController.clear();
                    }
                  },
                  child: CircleAvatar(
                    radius: 24.0,
                    backgroundColor: Colors.black,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;
  final String currentUser;
  final Function(String) onDelete;

  const CommentCard({
    super.key,
    required this.comment,
    required this.currentUser,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Padding horizontal ditambahkan
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${comment.user} ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        comment.comment,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0), // Jarak antara teks dan timestamp
                Text(
                  comment.timestamp,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          if (comment.user == currentUser)
            IconButton(
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () => onDelete(comment.commentId),
            ),
        ],
      ),
    );
  }
}

class Comment {
  final String commentId;
  final String user;
  final String comment;
  final String timestamp;

  Comment({
    required this.commentId,
    required this.user,
    required this.comment,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['uuid'],
      user: json['user'],
      comment: json['comment'],
      timestamp: json['timestamp'],
    );
  }
}
