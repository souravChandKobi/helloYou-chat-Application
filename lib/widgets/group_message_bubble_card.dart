import 'dart:math' hide log;
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/helper/my_date_util.dart';
import 'package:ss_chat/models/group_messages.dart';
import 'package:ss_chat/widgets/fullScreenImage.dart';

class GroupMessageCard extends StatefulWidget {
  const GroupMessageCard({super.key, required this.groupMessage});
  final GroupMessage groupMessage;

  @override
  State<GroupMessageCard> createState() => _GroupMessageCardState();
}

class _GroupMessageCardState extends State<GroupMessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.groupMessage.fromId
        ? _greenBubble()
        : _blueBubble();
    // return _greenBubble();
  }

  // --------------------- SENDER MESSAGE BUBBLE ---------------------
  Widget _blueBubble() {
    // to update the read status if it's empty
    if (widget.groupMessage.read.isEmpty) {
      APIs.updateGroupMessageReadStatus(widget.groupMessage);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // message card design
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                //size of the chat bubble
                padding: EdgeInsets.all(
                  max(
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width
                  ) *0.016
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF3C4142),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),

                // text message inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // user Name
                    Text(
                      widget.groupMessage.fromName,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.0),

                    // message
                    // Text(
                    //   widget.groupMessage.msg,
                    //   style: TextStyle(color: Colors.white),
                    // ),

                    //MESSAGE
                    widget.groupMessage.type == groupMessageType.text
                        ? Text(
                            widget.groupMessage.msg,
                            style: TextStyle(color: Colors.white),
                          )
                        : GestureDetector(
                            
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(12),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),

                              child: SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.09,
                                // height: MediaQuery.of(context).size.width * 0.09,
                                width:
                                    min(
                                      MediaQuery.of(context).size.width,
                                      MediaQuery.of(context).size.height,
                                    ) *
                                    0.6,
                                height:
                                    min(
                                      MediaQuery.of(context).size.width,
                                      MediaQuery.of(context).size.height,
                                    ) *
                                    0.6,

                                child: CachedNetworkImage(
                                  imageUrl: widget.groupMessage.msg,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(CupertinoIcons.person, size: 30),
                                ),
                              ),
                            ),

                            onTap: () {
                          log('Image Clicked');
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>
                          FullScreenImage(imageUrl: widget.groupMessage.msg)
                          ));
                        },
                          ),
                          
                  ],
                ),
              ),
            ),

            // time and date under the message card
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Row(
                children: [
                  Text(
                    MyDateUtil.getLastMessageTimeForMessageCard(
                      context: context,
                      time: widget.groupMessage.sentAt,
                    ),
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  // Icon(Icons.done_all_rounded, color: Colors.white, size: 14),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --------------------- OUR MESSAGE BUBBLE ---------------------
  Widget _greenBubble() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // message card design
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                //size of the chat bubble
                padding: EdgeInsets.all(
                  max(
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width
                  ) * 0.016,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF075E54),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),

                // text message inside the card
                // child: Text(
                //   widget.groupMessage.msg,
                //   style: TextStyle(color: Colors.white),
                // ),

                child: widget.groupMessage.type == groupMessageType.text
                    ? Text(
                        widget.groupMessage.msg,
                        style: TextStyle(color: Colors.white),
                      )
                    : GestureDetector(
                        
                        child: ClipRRect(
                          // borderRadius: BorderRadius.circular(12),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),

                          child: SizedBox(
                            // width: MediaQuery.of(context).size.width * 0.09,
                            // height: MediaQuery.of(context).size.width * 0.09,
                            width:
                                min(
                                  MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height,
                                ) *
                                0.6,
                            height:
                                min(
                                  MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height,
                                ) *
                                0.6,

                            child: CachedNetworkImage(
                              imageUrl: widget.groupMessage.msg,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(CupertinoIcons.person, size: 30),
                            ),
                          ),
                        ),

                        onTap: () {
                          log('Image Clicked');
                          Navigator.push(context, MaterialPageRoute(builder: (_)=> FullScreenImage(imageUrl: widget.groupMessage.msg)));
                        },
                      ),

              ),
            ),

            // time and date under the message card
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Row(
                children: [
                  Text(
                    MyDateUtil.getLastMessageTimeForMessageCard(
                      context: context,
                      time: widget.groupMessage.sentAt,
                    ),
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  // widget.groupMessage.read.isNotEmpty ?
                  // Icon(Icons.done_all_rounded, color: Colors.blue, size: 14):Icon(Icons.done_all_rounded, color: Colors.white, size: 14)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
