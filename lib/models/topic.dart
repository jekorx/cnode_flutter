import './author.dart';
import '../utils/index.dart';

class Topic {
  final String id;
  final Author author;
  final String title;
  final String lastReplyAt;
  Topic({
    this.id,
    this.author,
    this.title,
    this.lastReplyAt
  });
  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json['id'] as String,
    author: Author.fromJson(json['author']),
    title: json['title'] as String,
    lastReplyAt: Utils.getTimeInfo(DateTime.parse(json['last_reply_at']))
  );
}