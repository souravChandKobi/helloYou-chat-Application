import 'dart:developer';
import 'dart:math' hide log;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/api/cloudinaryApi.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/models/message.dart';
import 'package:ss_chat/pageTransitions/slide_animation.dart';
import 'package:ss_chat/screens/profile_screen_others.dart';
import 'package:ss_chat/widgets/chat_message_bubble_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // --------------------- Variables ---------------------
  // List<Message> list = [];

  //for disabling the image button
  bool _isPicking = false;

  //for handling message text changes
  final _textController = TextEditingController();
  bool showEmoji = false;
  final FocusNode _focusNode = FocusNode();

  // ScrollController to control ListView to auto scroll to latest message
  // final ScrollController _scrollController = ScrollController();

  // late ChatUser chatUser;
  //   @override
  // void initState() {
  //   super.initState();
  //   chatUser = widget.user; // 👈 assign the passed user
  //   APIs.listenToMessageStatus(chatUser, (message) {
  //     // handle the message status update
  //     final index = list.indexWhere((m) => m.sentAt == message.sentAt);
  //     if (index != -1) {
  //       list[index].status = message.status;
  //     } else {
  //       list.add(message);
  //     }
  //     setState(() {});
  //   });
  // }

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
          // setResult!;

          // Do not pop the route manually
          return;
        }

        // If emoji picker is hidden, allow normal back
        Navigator.maybePop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        // --------------------- App Bar ---------------------
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          titleSpacing: 0,
          
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(
                SlideFromRightPageRoute(
                  page: ProfileScreenOthers(user: widget.user),
                  duration: const Duration(milliseconds: 100),
                  reverseDuration: const Duration(milliseconds: 50),
                ),
              );
            },
            child: Row(
              //profile picture
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

                SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    //user name and info on appbar
                    children: [
                      Text(widget.user.name, style: TextStyle(fontSize: 18)),
                      SizedBox(height: 1),
                      Text(
                        'Last seen: 10:00 AM',
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                // SizedBox(width: 13),

                // Expanded(
                //   child:
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),

                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.call_outlined),
                    ),
                  ],
                ),
                // ),
              ],
            ),
          ),

          //options menu 3 dots
          actions: [
            PopupMenuButton<String>(
              color: Color.fromARGB(255, 0, 15, 1),
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ), // three-dot icon
              // Offset: x=0, y = AppBar height (kToolbarHeight) + extra spacing
              offset: Offset(0, kToolbarHeight),

              // offset: Offset(0, 55),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'settings',
                  child: Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'help',
                  child: Text('Help', style: TextStyle(color: Colors.white)),
                ),
                // PopupMenuItem(value: 'sign out', child: Text('Sign Out')),
              ],
              onSelected: (value) async {
                switch (value) {
                  case 'settings':
                    log("\nSettings clicked");
                    break;
                  case 'help':
                    log("\nHelp clicked");
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
                    stream: APIs.getAllMessages(widget.user),
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
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          //sorting the messages array so that the newest msg takes index[0]
                          messages.sort(
                            (a, b) => int.parse(
                              b.sentAt,
                            ).compareTo(int.parse(a.sentAt)),
                          );

                          // log("index 0: ${messages[0].msg}");

                          if (messages.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,

                              // controller: _scrollController, // scroll controller
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,

                              itemCount: messages.length,

                              // physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 8),
                              itemBuilder: (context, index) {
                                return MessageCard(message: messages[index]);
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

                // --------------------- Chat Input ---------------------
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.005,
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        // child: Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 8,
                        //     vertical: 4,
                        //   ),
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _textController,
                          onTap: () {
                            setState(() => showEmoji = false);
                          },
                          style: TextStyle(color: Colors.white),
                          // controller: _textController,
                          //to make the text in the text box multiline
                          keyboardType: TextInputType.multiline,
                          maxLines: null,

                          decoration: InputDecoration(
                            hintText: 'Message',
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 184, 178, 178),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 0, 24, 10),

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
                                color: const Color.fromARGB(255, 255, 255, 255),
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
                                          APIs.sendMessage(
                                            widget.user,
                                            imageUrl,
                                            Type.image,
                                          );
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
                        // ),
                      ),

                      //send message button
                      IconButton(
                        onPressed: () async {
                          log('\nsend pressed');

                          if (_textController.text.isNotEmpty) {
                            APIs.sendMessage(
                              widget.user,
                              _textController.text,
                              Type.text,
                            );
                            _textController.clear();
                          }
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
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
        // chat input field bottom
      ),
    );
  }
}
