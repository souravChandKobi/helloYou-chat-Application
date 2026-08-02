import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class FullScreenImage extends StatelessWidget {
  final imageUrl;
  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: CachedNetworkImage(imageUrl: imageUrl),
    );
  }
}