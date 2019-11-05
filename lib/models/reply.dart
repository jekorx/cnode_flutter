import './author.dart';
import '../utils/index.dart';

class Reply {
  final String id;
  final Author author;
  final String content;
  final List ups;
  final String createAt;
  final String replyId;
  final bool isUped;
  Reply({
    this.id,
    this.author,
    this.content,
    this.ups,
    this.createAt,
    this.replyId,
    this.isUped
  });
  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    id: json['id'] as String,
    author: Author.fromJson(json['author']),
    content: json['content'] as String,
    ups: json['ups'] as List,
    createAt: Utils.getTimeInfo(DateTime.parse(json['create_at'])),
    replyId: json['reply_id'] as String,
    isUped: json['is_uped'] as bool
  );
}