import 'dart:math' hide log;
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/helper/my_date_util.dart';
import 'package:ss_chat/models/message.dart';
import 'package:ss_chat/widgets/fullScreenImage.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  // --------------------- Sender Message (Blue/left) ---------------------
  Widget _blueMessage() {
    // Update read status if empty
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message card design
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                //size of the chat bubble
                padding: EdgeInsets.all(
                  max(
                        MediaQuery.of(context).size.height,
                        MediaQuery.of(context).size.width,
                      ) *
                      0.016,
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
                child: Column(
                  children: [
                    //MESSAGE
                    widget.message.type == Type.text
                        ? Text(
                            widget.message.msg,
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
                                  imageUrl: widget.message.msg,
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
                          FullScreenImage(imageUrl: widget.message.msg)
                          ));
                        },
                          ),
                  ],
                ),
              ),
            ),

            // Time & date
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Row(
                children: [
                  Text(
                    MyDateUtil.getLastMessageTimeForMessageCard(
                      context: context,
                      time: widget.message.sentAt,
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

  // --------------------- User Message (Green/right) ---------------------
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Message card design
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                //size of the message bubble
                padding: EdgeInsets.all(
                  max(
                        MediaQuery.of(context).size.height,
                        MediaQuery.of(context).size.width,
                      ) *
                      0.016,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF075E54),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                //check wether the msg is text or image
                child: widget.message.type == Type.text
                    ? Text(
                        widget.message.msg,
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
                              imageUrl: widget.message.msg,
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
                          Navigator.push(context, MaterialPageRoute(builder: (_)=> FullScreenImage(imageUrl: widget.message.msg)));
                        },
                      ),
              ),
            ),

            // Time & date
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Row(
                children: [
                  Text(
                    MyDateUtil.getLastMessageTimeForMessageCard(
                      context: context,
                      time: widget.message.sentAt,
                    ),
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  // widget.message.read.isNotEmpty ?
                  // Icon(Icons.done_all_rounded, color: Colors.blue, size: 14):Icon(Icons.done_all_rounded, color: Colors.white, size: 14)

                  // Status icon
                  if (widget.message.read.isNotEmpty)
                    const Icon(
                      Icons.done_all_rounded,
                      color: Colors.blue,
                      size: 14,
                    )
                  else if (widget.message.dbReceivedAt.isNotEmpty)
                    const Icon(
                      Icons.done_all_rounded,
                      color: Colors.white,
                      size: 14,
                    )
                  else
                    const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                      size: 14,
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
