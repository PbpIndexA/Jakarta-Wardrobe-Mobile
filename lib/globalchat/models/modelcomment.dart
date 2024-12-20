// import 'dart:convert';

// class CommentResponse {
//     final List<Comment> comments;

//     CommentResponse({
//         required this.comments,
//     });

//     factory CommentResponse.fromJson(Map<String, dynamic> json) => CommentResponse(
//         comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
//     );
// }

// class Comment {
//     final String id;
//     final String text;
//     final String user;
//     final DateTime postedTime;

//     Comment({
//         required this.id,
//         required this.text,
//         required this.user,
//         required this.postedTime,
//     });

//   factory Comment.fromJson(Map<String, dynamic> json) => Comment(
//     id: json["id"],
//     text: json["text"],
//     user: json["user"],
//     postedTime: DateTime.parse(json["posted_time"]),
//   );
// }
// To parse this JSON data, do
//
//     final globalChat = globalChatFromJson(jsonString);

import 'dart:convert';

GlobalChat globalChatFromJson(String str) => GlobalChat.fromJson(json.decode(str));

String globalChatToJson(GlobalChat data) => json.encode(data.toJson());

class GlobalChat {
    List<Comment> comments;

    GlobalChat({
        required this.comments,
    });

    factory GlobalChat.fromJson(Map<String, dynamic> json) => GlobalChat(
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    };
}

class Comment {
    int id;
    String text;
    String user;
    DateTime postedTime;

    Comment({
        required this.id,
        required this.text,
        required this.user,
        required this.postedTime,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        text: json["text"],
        user: json["user"],
        postedTime: DateTime.parse(json["posted_time"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "user": user,
        "posted_time": postedTime.toIso8601String(),
    };
}
