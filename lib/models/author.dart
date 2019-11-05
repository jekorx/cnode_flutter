class Author {
  final String loginname;
  final String avatarUrl;
  Author({ this.loginname, this.avatarUrl });
  factory Author.fromJson(Map<String, dynamic> json) => Author(
    loginname: json['loginname'] as String,
    avatarUrl: json['avatar_url'] as String
  );
}