import './author.dart';
import '../utils/index.dart';

class Article {

  static const Map<String, String> TAB_MAP = {
    'ask': '问答',
    'share': '分享',
    'job': '招聘',
    'dev': '测试'
  };

  final String id;
  final String authorId;
  final String tab;
  final String content;
  final String title;
  final String lastReplyAt;
  final bool good;
  final bool top;
  final int replyCount;
  final int visitCount;
  final String createAt;
  final Author author;
  Article({
    this.id,
    this.authorId,
    this.tab,
    this.content,
    this.title,
    this.lastReplyAt,
    this.good,
    this.top,
    this.replyCount,
    this.visitCount,
    this.createAt,
    this.author
  });
  factory Article.fromJson(Map<String, dynamic> json) => Article(
    id: json['id'] as String,
    authorId: json['author_id'] as String,
    tab: json['tab'] as String,
    content: json['content'] as String,
    title: json['title'] as String,
    lastReplyAt: Utils.getTimeInfo(DateTime.parse(json['last_reply_at'])),
    good: json['good'] as bool,
    top: json['top'] as bool,
    replyCount: json['reply_count'] as int,
    visitCount: json['visit_count'] as int,
    createAt: Utils.getTimeInfo(DateTime.parse(json['create_at'])),
    author: Author.fromJson(json['author'])
  );
}