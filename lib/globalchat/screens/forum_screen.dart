import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:jawa_app/globalchat/models/modelforum.dart';
import 'package:jawa_app/shared/widgets/drawer.dart';
// Jika forum_screen.dart juga ada di folder screens
import 'package:jawa_app/globalchat/screens/create_forum_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  String _currentFilter = 'newest';
  // int _currentPage = 1;
  bool _isLoading = false;
  // final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     if (!_isLoading) {
  //       setState(() {
  //         _currentPage++;
  //         _fetchForums(context.read<CookieRequest>());
  //       });
  //     }
  //   }
  // }

  Future<GlobalChat> fetchForums(CookieRequest request) async {
    List<Forum> allForums = [];
    bool hasNext = true;
    int page = 1;

    while (hasNext) {
      final response = await request.get(
        'http://127.0.0.1:8000/globalChat/api/global_chat/?filter=$_currentFilter&page=$page'
      );
      
      final GlobalChat currentPage = GlobalChat.fromJson(response);
      allForums.addAll(currentPage.forums);
      
      hasNext = currentPage.hasNext;
      page++;
    }

    // Buat objek GlobalChat baru dengan semua forum yang terkumpul
    return GlobalChat(
      forums: allForums,
      totalPages: 1,
      currentPage: 1,
      hasPrevious: false,
      hasNext: false,
    );
  }

  Future<void> _fetchForums(CookieRequest request) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await fetchForums(request);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load forums')),
        );
      }
    }
  }

  Future<void> toggleLike(CookieRequest request, int forumId) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/globalChat/api/forum/$forumId/like/',
        {},
      );

      if (response['success']) {
        setState(() {
          // Refresh the forums list
          _fetchForums(request);
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
          // Refresh the forums list
          _fetchForums(request);
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
        title: const Text(
          'Forums',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onSelected: (String value) {
              setState(() {
                _currentFilter = value;
                // _currentPage = 1;
              });
              _fetchForums(request);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'newest',
                child: Text('Newest'),
              ),
              const PopupMenuItem(
                value: 'most_likes',
                child: Text('Most Likes'),
              ),
              const PopupMenuItem(
                value: 'your_posts',
                child: Text('Your Posts'),
              ),
              const PopupMenuItem(
                value: 'saved',
                child: Text('Saved'),
              ),
            ],
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<GlobalChat>(
        future: fetchForums(request),
        builder: (context, AsyncSnapshot<GlobalChat> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.forums.isEmpty) {
            return const Center(
              child: Text(
                'No forums available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            // controller: _scrollController,
            // itemCount:
            //     snapshot.data!.forums.length + (snapshot.data!.hasNext ? 1 : 0),
            itemCount: snapshot.data!.forums.length, 
            itemBuilder: (context, index) {
              // if (index == snapshot.data!.forums.length) {
              //   return const Center(
              //     child: Padding(
              //       padding: EdgeInsets.all(8.0),
              //       child: CircularProgressIndicator(),
              //     ),
              //   );
              // }

              final forum = snapshot.data!.forums[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[800],
                            child: Text(forum.user[0].toUpperCase()),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  forum.user,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('MMM d, yyyy HH:mm')
                                      .format(forum.postedTime),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(
                              forum.purpose,
                              style: const TextStyle(
                                fontSize: 11.0,  // Ukuran font dikecilkan dari 12 ke 10
                                color: Colors.black,
                              ),
                            ),
                            backgroundColor: const Color.fromARGB(255, 249, 238, 229),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0),  // Mengurangi padding dalam
                            padding: const EdgeInsets.all(4.0),  // Mengurangi padding luar
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Membuat chip lebih compact
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        forum.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        forum.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            onPressed: () => toggleLike(request, forum.id),
                          ),
                          Text('${forum.likeCount}'),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(
                              Icons.bookmark_border,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            onPressed: () => toggleBookmark(request, forum.id),
                          ),
                          Text('${forum.bookmarkCount}'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateForumScreen()),
          );
          // Refresh forum list if new forum was created
          if (created == true) {
            setState(() {
              // _currentPage = 1; // Reset ke halaman pertama
            });
            _fetchForums(request); 
            // _fetchForums(request);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
