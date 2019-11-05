import 'package:flutter/material.dart';
import '../components/avatar.dart';
import '../components/html_rich_text.dart';
import '../models/reply.dart';

class ReplyItem extends StatefulWidget {
  // 回复
  final Reply reply;
  // 索引，楼数
  final int index;

  ReplyItem(this.reply, this.index, { Key key }) : super(key: key);

  @override
  _ReplyItemState createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  // 操作按钮默认颜色
  final Color _optColor = Color(0xff666666);
  // 操作按钮激活颜色
  final Color _optColorActive = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: Color(0xffeeeeee))),
      ),
      padding: EdgeInsets.only(top: 16, right: 12, bottom: 10, left: 12),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10, right: 12),
                child: Avatar(widget.reply.author.avatarUrl),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(widget.reply.author.loginname),
                        Text(
                          '  ${widget.index} 楼 · ${widget.reply.createAt}',
                          style: TextStyle(color: _optColorActive),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 26,
                          child: IconButton(
                            iconSize: 15,
                            icon: Icon(Icons.thumb_up),
                            color: widget.reply.isUped ? _optColorActive : _optColor,
                            highlightColor: Color(0xfffafafa),
                            splashColor: Color(0xfffafafa),
                            onPressed: () {},
                          ),
                        ),
                        Text(
                          '${widget.reply.ups.length}',
                          style: TextStyle(color: _optColor,fontSize: 13),
                        ),
                        SizedBox(
                          width: 28,
                          child: IconButton(
                            iconSize: 22,
                            icon: Icon(Icons.reply),
                            color: _optColor,
                            highlightColor: Color(0xfffafafa),
                            splashColor: Color(0xfffafafa),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          HtmlRichText(widget.reply.content),
        ],
      ),
    );
  }
}