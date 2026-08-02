import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ss_chat/helper/my_date_util.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/models/message.dart';
import 'package:ss_chat/pageTransitions/slide_animation.dart';
import 'package:ss_chat/screens/chat_screen.dart';
import '../api/apis.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: BoxBorder.symmetric(),
      color: Color.fromARGB(255, 0, 12, 1),
      child: InkWell(
        onTap: () async {
          await Future.delayed(Duration(milliseconds: 150));
          Navigator.of(context).push(
            SlideFromRightPageRoute(
              page: ChatScreen(user: widget.user),
              duration: const Duration(milliseconds: 250),
              reverseDuration: const Duration(milliseconds: 125),
            ),
          );
        },

        // --------------------- StreamBuilder for Last Message ---------------------
        child: StreamBuilder<Message?>(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final lastMsg = snapshot.data;

            return ListTile(
              // --------------------- Profile Picture ---------------------
              leading: ClipOval(
                child: SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.12,
                  // height: MediaQuery.of(context).size.width * 0.12,

                  // use the smaller side for both width and height
                  width:
                      min(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height,
                      ) *
                      0.12,
                  height:
                      min(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height,
                      ) *
                      0.12,
                  child: CachedNetworkImage(
                    imageUrl: widget.user.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(CupertinoIcons.person, size: 30),
                  ),
                ),
              ),

              // --------------------- User Name ---------------------
              title: Text(
                widget.user.name,
                style: TextStyle(color: Colors.white),
              ),

              // --------------------- Last Message & Read Status ---------------------
              subtitle: Row(
                children: [
                  // if (lastMsg != null && lastMsg.fromId == APIs.user.uid)
                  //   Icon(
                  //     Icons.done_all_rounded,
                  //     size: 14,
                  //     color: lastMsg.read.isNotEmpty ? Colors.blue : Colors.white,
                  //   ),
                  if (lastMsg != null && lastMsg.fromId == APIs.user.uid) ...[
                    // Status icon logic
                    if (lastMsg.read.isNotEmpty)
                      const Icon(
                        Icons.done_all_rounded,
                        size: 14,
                        color: Colors.blue,
                      )
                    else if (lastMsg.dbReceivedAt.isNotEmpty)
                      const Icon(
                        Icons.done_all_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    else
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey,
                      ),
                  ],

                  Expanded(
                    child: Text(
                      lastMsg != null && lastMsg.msg.isNotEmpty
                          ? lastMsg.msg
                          : widget.user.about,
                      style: const TextStyle(color: Colors.white54),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // --------------------- Trailing: Time & Unread Indicator ---------------------
              trailing: lastMsg == null
                  ? null
                  : lastMsg.read.isEmpty && lastMsg.fromId != APIs.user.uid
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // New unread message indicator
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Icon(
                                Icons.circle,
                                color: Color(0xFF97d68f),
                                size: 15,
                              ),
                            ),
                            Text(
                              '', // optional text overlay
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          MyDateUtil.getLastMessageTime(
                            context: context,
                            time: lastMsg.sentAt,
                          ),
                          style: TextStyle(color: Color(0xFF97d68f)),
                        ),
                      ],
                    )
                  // If message is read
                  : Text(
                      MyDateUtil.getLastMessageTime(
                        context: context,
                        time: lastMsg.sentAt,
                      ),
                      style: TextStyle(color: Colors.white54),
                    ),
            );
          },
        ),
      ),
    );
  }
}
