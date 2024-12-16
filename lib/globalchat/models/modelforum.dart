// To parse this JSON data, do
//
//     final globalChat = globalChatFromJson(jsonString);

import 'dart:convert';

GlobalChat globalChatFromJson(String str) =>
    GlobalChat.fromJson(json.decode(str));

String globalChatToJson(GlobalChat data) => json.encode(data.toJson());

class GlobalChat {
  List<Forum> forums;
  int totalPages;
  int currentPage;
  bool hasPrevious;
  bool hasNext;

  GlobalChat({
    required this.forums,
    required this.totalPages,
    required this.currentPage,
    required this.hasPrevious,
    required this.hasNext,
  });

  factory GlobalChat.fromJson(Map<String, dynamic> json) => GlobalChat(
        forums: List<Forum>.from(json["forums"].map((x) => Forum.fromJson(x))),
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        hasPrevious: json["has_previous"],
        hasNext: json["has_next"],
      );

  Map<String, dynamic> toJson() => {
        "forums": List<dynamic>.from(forums.map((x) => x.toJson())),
        "total_pages": totalPages,
        "current_page": currentPage,
        "has_previous": hasPrevious,
        "has_next": hasNext,
      };
}

class Forum {
  int id;
  String title;
  String description;
  String purpose;
  String user;
  DateTime postedTime;
  int likeCount;
  int bookmarkCount;

  Forum({
    required this.id,
    required this.title,
    required this.description,
    required this.purpose,
    required this.user,
    required this.postedTime,
    required this.likeCount,
    required this.bookmarkCount,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        purpose: json["purpose"],
        user: json["user"],
        postedTime: DateTime.parse(json["posted_time"]),
        likeCount: json["like_count"],
        bookmarkCount: json["bookmark_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "purpose": purpose,
        "user": user,
        "posted_time": postedTime.toIso8601String(),
        "like_count": likeCount,
        "bookmark_count": bookmarkCount,
      };
}