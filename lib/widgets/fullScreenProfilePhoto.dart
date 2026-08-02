import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/api/cludinaryGroupPhoto.dart';
import 'package:ss_chat/models/chat_user.dart';

class FullScreenProfilePhoto extends StatefulWidget {
  final imageUrl;
  final ChatUser user;
  const FullScreenProfilePhoto({super.key, required this.imageUrl,required this.user});

  @override
  State<FullScreenProfilePhoto> createState() => _FullScreenProfilePhotoState();
}

class _FullScreenProfilePhotoState extends State<FullScreenProfilePhoto> {
  bool _isPicking = false;
  bool iscurrentuser = APIs.user.uid==APIs.me.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // --------------------- AppBar ---------------------
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(children: [Text('Profile Photo')]),

        // Edit Button
        actions: [
         iscurrentuser?
          IconButton(
            onPressed: _isPicking
                ? null
                : () async {
                  log(APIs.user.uid);
                    setState(() => _isPicking = true);

                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      log(
                        "image path: ${image.path} --Mime Type: ${image.mimeType}",
                      );
                      String? imageUrl = await CloudinaryGroupPhoto.upload(
                        image,
                      );

                      if (imageUrl != null) {
                        log("image Url: $imageUrl");
                        // APIs.sendMessage(
                        //   widget.user,
                        //   imageUrl,
                        //   Type.image,
                        // );
                        // APIs.me.image = imageUrl.toString();
                        await APIs.updateProfilePhoto(imageUrl);
                        
                      }
                    }

                    // APIs.sendMessage(widget.user, File(image.path));

                    setState(() => _isPicking = false);
                  },
            icon: Icon(Icons.edit),
          ):const SizedBox(),
        ],
      ),

      body: Container(
        // height: 100,
        // width: 100,
        child: CachedNetworkImage(imageUrl: widget.imageUrl),
      ),
    );
  }
}
