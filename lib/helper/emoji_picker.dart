import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

class EmojiPickerWidget extends StatelessWidget {
  final TextEditingController textController;

  const EmojiPickerWidget({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      textEditingController: textController,
      onBackspacePressed: () {},
      config: Config(
        height: 256,
        emojiViewConfig: EmojiViewConfig(
          backgroundColor: Colors.black87,
          emojiSizeMax: 28 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.2 : 1.0),
        ),
        categoryViewConfig: const CategoryViewConfig(
          backgroundColor: Colors.black87,
          iconColor: Colors.white54,
          iconColorSelected: Colors.white,
        ),
        bottomActionBarConfig: const BottomActionBarConfig(
          backgroundColor: Colors.black87,
        ),
        searchViewConfig: const SearchViewConfig(
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
