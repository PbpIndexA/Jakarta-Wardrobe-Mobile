import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
    String username;
    String profilePicture;

    Profile({
        required this.username,
        required this.profilePicture,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        username: json["username"],
        profilePicture: json["profile_picture"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "profile_picture": profilePicture,
    };
}
