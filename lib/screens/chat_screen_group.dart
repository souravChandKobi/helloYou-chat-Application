import 'dart:developer';
import 'dart:math' hide log;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ss_chat/api/cloudinaryApi.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ss_chat/models/group_messages.dart';
import 'package:flutter/material.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/models/groups.dart';
import 'package:ss_chat/pageTransitions/slide_animation.dart';
import 'package:ss_chat/screens/add_member_screen.dart';
import 'package:ss_chat/screens/profile_screen_group.dart';
import 'package:ss_chat/widgets/group_message_bubble_card.dart';

class GroupChatScreen extends StatefulWidget {
  final Group group;
  const GroupChatScreen({super.key, required this.group});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  // --------------------- Controllers ---------------------
  final _textController = TextEditingController();
  bool showEmoji = false;
  //for disabling the image button
  bool _isPicking = false;
  final FocusNode _focusNode = FocusNode();

  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !showEmoji, // Prevent back gesture if emoji picker is visible
      onPopInvokedWithResult: (didPop, setResult) {
        if (showEmoji) {
          // Hide emoji picker instead of popping the screen
          setState(() => showEmoji = false);

          // Optionally set a result if needed
          // setResult!(null);

          // Do not pop the route manually
          return;
        }

        // If emoji picker is hidden, allow normal back
        Navigator.maybePop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        // --------------------- AppBar ---------------------
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          titleSpacing: 0,

          title: InkWell(
            onTap: () {
              Navigator.of(context).push(
                SlideFromRightPageRoute(
                  page: ProfileScreenGroup(group: widget.group),
                  duration: const Duration(milliseconds: 100),
                  reverseDuration: const Duration(milliseconds: 50),
                ),
              );
            },
            child: Row(
              //group profile pic
              children: [
                ClipOval(
                  child: SizedBox(
                    // width: MediaQuery.of(context).size.width * 0.09,
                    // height: MediaQuery.of(context).size.width * 0.09,
                    width:
                        min(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height,
                        ) *
                        0.1,
                    height:
                        min(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height,
                        ) *
                        0.1,

                    child: CachedNetworkImage(
                      imageUrl: widget.group.image,
                      fit: BoxFit.cover,
                      // placeholder: (context, url) =>
                      //     Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      placeholder: (context, url) =>
                          Image.asset('images/icon.png', fit: BoxFit.cover),
                      errorWidget: (context, url, error) =>
                          Icon(CupertinoIcons.person, size: 30),
                    ),
                  ),
                ),
                SizedBox(width: 13),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.group.groupName,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Last seen: 10:00 AM',
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          actions: [
            PopupMenuButton<String>(
              color: Color.fromARGB(255, 0, 15, 1),
              icon: Icon(Icons.more_vert, color: Colors.white),
              offset: Offset(0, kToolbarHeight),
              itemBuilder: (context) => [
                PopupMenuItem(value: 'settings', child: Text('Settings',style: TextStyle(color: Colors.white))),
                PopupMenuItem(value: 'Add Member', child: Text('Add Member',style: TextStyle(color: Colors.white))),
                // PopupMenuItem(value: 'sign out', child: Text('Sign Out')),
              ],
              onSelected: (value) async {
                switch (value) {
                  case 'settings':
                    log("\nSettings clicked");
                    break;
                  case 'Add Member':
                    Navigator.of(context).push(
                      SlideFromRightPageRoute(
                        page: AddMemberScreen(groupId: widget.group.id),
                      ),
                    );
                    log('Current Group ID gcs: ${widget.group.id}');
                    log("\nAdd Member clicked");
                    break;
                }
              },
            ),
          ],
        ),

        // --------------------- Body ---------------------
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 0, 0, 0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // --------------------- Messages ---------------------
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllGroupMessages(widget.group.id),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const SizedBox(); //MAKES THE SCREEN STUTTER

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          final messages =
                              data
                                  ?.map((e) => GroupMessage.fromJson(e.data()))
                                  .toList() ??
                              [];

                          // final messages =
                          //     data
                          //         ?.map(
                          //           (e) => GroupMessage.fromDoc(
                          //             e.id,
                          //             e.data() as Map<String, dynamic>,
                          //           ),
                          //         )
                          //         .toList() ?? [];

                          // messages.sort((a, b) => int.parse(b.sentAt).compareTo(int.parse(a.sentAt)));
                          // log("index 0: ${messages[0].msg}");

                          if (messages.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: messages.length,
                              padding: EdgeInsets.only(top: 8),
                              itemBuilder: (context, index) {
                                return GroupMessageCard(
                                  groupMessage: messages[index],
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),

                // --------------------- Chat Input Box ---------------------
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.005,
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _textController,
                          onTap: () {
                            setState(() => showEmoji = false);
                          },
                          style: TextStyle(color: Colors.white),
                          // controller: _textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 184, 178, 178),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 0, 24, 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            //emoji icon at inside the text field -leading
                            prefixIcon: IconButton(
                              onPressed: () {
                                if (showEmoji) {
                                  // Emoji is visible → hide emoji, show keyboard
                                  setState(() => showEmoji = false);
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(_focusNode);
                                } else {
                                  // Keyboard is visible → hide keyboard first, then show emoji
                                  FocusScope.of(context).unfocus();

                                  // Delay showing emoji until keyboard is fully hidden
                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () {
                                      if (mounted) {
                                        setState(() => showEmoji = true);
                                      }
                                    },
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.emoji_emotions_rounded,
                                color: Colors.white,
                              ),
                            ),

                            // gallery icon inside the text field trailing
                            suffixIcon: IconButton(
                              onPressed: _isPicking
                                  ? null
                                  : () async {
                                      setState(() => _isPicking = true);

                                      final ImagePicker picker = ImagePicker();
                                      // Pick an image.
                                      final XFile? image = await picker
                                          .pickImage(
                                            source: ImageSource.gallery,
                                          );
                                      if (image != null) {
                                        log(
                                          "image path: ${image.path} --Mime Type: ${image.mimeType}",
                                        );
                                        String? imageUrl =
                                            await CloudinaryUploader.upload(
                                              image,
                                            );

                                        if (imageUrl != null) {
                                          log("image Url: $imageUrl");
                                          // APIs.sendGroupMessage(
                                          //   widget.group.id,
                                          //   imageUrl,
                                          //   groupMessageType.image,
                                          // );
                                          APIs.sendGroupMessage(widget.group.id, imageUrl, groupMessageType.image);
                                        }
                                      }

                                      // APIs.sendMessage(widget.user, File(image.path));

                                      setState(() => _isPicking = false);
                                    },
                              icon: Icon(
                                Icons.image_rounded,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () async {
                          log('\nsend pressed');
                          if (_textController.text.isNotEmpty) {
                            APIs.sendGroupMessage(
                              widget.group.id,
                              _textController.text,
                              groupMessageType.text
                            );
                            _textController.clear();
                          }
                        },
                        icon: Icon(Icons.send_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                //emoji picker
                Offstage(
                  offstage: !showEmoji,
                  child: EmojiPicker(textEditingController: _textController),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
