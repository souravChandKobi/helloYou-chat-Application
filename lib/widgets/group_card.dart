import 'dart:math' show min;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/helper/my_date_util.dart';
import 'package:ss_chat/models/groups.dart';
import 'package:ss_chat/pageTransitions/slide_animation.dart';
import 'package:ss_chat/screens/chat_screen_group.dart';

class GroupCard extends StatefulWidget {
  final Group group;

  const GroupCard({super.key, required this.group});

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      shape: BoxBorder.symmetric(),
      color: Color.fromARGB(255, 0, 12, 1),

      child: InkWell(
        onTap: () async {
          await Future.delayed(Duration(milliseconds: 150));
          Navigator.of(context).push(
            SlideFromRightPageRoute(page: GroupChatScreen(group: widget.group)),
          );
        },

        // --------------------- StreamBuilder for Last Group Message ---------------------
        child: StreamBuilder(
          stream: APIs.getGroupLastMessage(widget.group.id),
          builder: (context, snapshot) {
            final lastGroupMsg = snapshot.data;

            return ListTile(
              // --------------------- Group Avatar ---------------------
              // leading: CircleAvatar(
              //   child: Icon(CupertinoIcons.person),
              // ),
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

                  // child: CachedNetworkImage(
                  //   imageUrl: widget.group.image,
                  //   fit: BoxFit.cover,
                  //   placeholder: (context, url) => Center(
                  //     child: CircularProgressIndicator(strokeWidth: 2),
                  //   ),
                  //   errorWidget: (context, url, error) =>
                  //       Icon(CupertinoIcons.person, size: 30),
                  // ),
                  child: CachedNetworkImage(
                    imageUrl: widget.group.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) {
                      final firstLetter = widget.group.groupName.isNotEmpty
                          ? widget.group.groupName[0].toUpperCase()
                          : '?';

                      return Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: Text(
                          firstLetter,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // --------------------- Group Name ---------------------
              title: Text(
                widget.group.groupName,
                style: TextStyle(color: Colors.white),
              ),

              // --------------------- Last Message Preview ---------------------
              subtitle: widget.group.lastMsg.isEmpty
                  ? null
                  : Text(
                      widget.group.lastMsg,
                      style: TextStyle(color: Colors.white54),
                      overflow: TextOverflow.ellipsis,
                    ),
              // subtitle: Text(
              //   lastMsg != null && lastMsg.msg.isNotEmpty
              //       ? lastMsg.msg
              //       : widget.user.about,
              //   style: const TextStyle(color: Colors.white54),
              //   overflow: TextOverflow.ellipsis,
              // ),

              // --------------------- Trailing: Time & Unread Indicator ---------------------
              trailing: lastGroupMsg == null
                  ? null
                  : lastGroupMsg.read.isEmpty &&
                        lastGroupMsg.fromId != APIs.user.uid
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
                            time: lastGroupMsg.sentAt,
                          ),
                          style: TextStyle(color: Color(0xFF97d68f)),
                        ),
                      ],
                    )
                  // If message is read
                  : Text(
                      MyDateUtil.getLastMessageTime(
                        context: context,
                        time: lastGroupMsg.sentAt,
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
