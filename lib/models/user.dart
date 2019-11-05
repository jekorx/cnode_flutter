import '../utils/index.dart';

class User {
  final String loginname;
  final String avatarUrl;
  final String githubUsername;
  final String createAt;
  final int score;
  User({
    this.loginname,
    this.avatarUrl,
    this.githubUsername,
    this.createAt,
    this.score
  });
  factory User.fromJson(Map<String, dynamic> json) => User(
    loginname: json['loginname'] as String,
    avatarUrl: json['avatar_url'] as String,
    githubUsername: json['githubUsername'] as String,
    createAt: Utils.getTimeInfo(DateTime.parse(json['create_at'])),
    score: json['score'] as int
  );
}