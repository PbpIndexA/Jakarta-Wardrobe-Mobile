import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/modelforum.dart';
import '../models/modelcomment.dart';
import 'dart:convert';

class ForumDetailScreen extends StatefulWidget {
  final Forum forum;

  const ForumDetailScreen({Key? key, required this.forum}) : super(key: key);

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [];
  bool isLoading = false;
  String? currentUser;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    currentUser = request.jsonData['username'];
    fetchComments(request);
  }

  Future<void> fetchComments(CookieRequest request) async {
    try {
      final response = await request.get(
        'http://127.0.0.1:8000/globalChat/api/forum/${widget.forum.id}/comments/',
      );

      if (response['comments'] != null && response['comments'] is List) {
        setState(() {
          comments = (response['comments'] as List)
              .map((comment) => Comment.fromJson(comment))
              .toList();
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load comments')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading comments: $e')),
        );
      }
    }
  }

  Future<void> addComment(CookieRequest request) async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/globalChat/api/forum/${widget.forum.id}/comment/',
        jsonEncode({"text": _commentController.text.trim()}),
      );

      print(response); // Debug respons server

      if (response != null && response['success'] == true) {
        _commentController.clear();
        fetchComments(request);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response?['message'] ?? 'Failed to add comment')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteComment(CookieRequest request, int commentId) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/globalChat/api/comment/delete/$commentId/',
        {},
      );

      if (response['success'] == true) {
        fetchComments(request);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(response['message'] ?? 'Failed to delete comment')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting comment: $e')),
        );
      }
    }
  }

  // Di bagian atas class _ForumDetailScreenState
  Future<void> toggleLike(CookieRequest request, int forumId) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/globalChat/api/forum/$forumId/like/',
        {},
      );

      if (response['success']) {
        setState(() {
          widget.forum.isLiked = !widget.forum.isLiked;
          widget.forum.likeCount += widget.forum.isLiked ? 1 : -1;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to toggle like')),
        );
      }
    }
  }

  Future<void> toggleBookmark(CookieRequest request, int forumId) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/globalChat/api/forum/$forumId/bookmark/',
        {},
      );

      if (response['success']) {
        setState(() {
          widget.forum.isBookmarked = !widget.forum.isBookmarked;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to toggle bookmark')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      // Di ForumDetailScreen, bagian body:
      body: Column(
        children: [
          // Main Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.forum.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Posted by ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          widget.forum.user,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' on ${DateFormat('dd/MM/yyyy').format(widget.forum.postedTime)} at ${DateFormat('HH:mm').format(widget.forum.postedTime)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(widget.forum.description),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Purpose: ',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        Chip(
                          label: Text(
                            widget.forum.purpose,
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: Colors.black,
                            ),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 249, 238, 229),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 6.0),
                          padding: const EdgeInsets.all(4.0),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            widget.forum.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                widget.forum.isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => toggleLike(request, widget.forum.id),
                        ),
                        Text(
                          '${widget.forum.likeCount}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.comment,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${comments.length}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(
                            widget.forum.isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: widget.forum.isBookmarked
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: () =>
                              toggleBookmark(request, widget.forum.id),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Comments Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Membuat sudut melengkung
                      ),
                      elevation: 0.5, // Tambahkan sedikit bayangan
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: comment.user,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            ' on ${DateFormat('dd/MM/yyyy').format(comment.postedTime)} at ${DateFormat('HH:mm').format(comment.postedTime)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (comment.user == currentUser)
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        size: 18, color: Colors.grey),
                                    onPressed: () =>
                                        deleteComment(request, comment.id),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              comment.text,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index <
                        comments.length -
                            1) // Tambahkan garis pemisah antar komentar
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        indent: 12.0,
                        endIndent: 12.0,
                      ),
                  ],
                );
              },
            ),
          ),

          // Comment Input
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add your comment...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: isLoading ? null : () => addComment(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Comment',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
