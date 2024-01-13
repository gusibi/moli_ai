import 'package:flutter/material.dart';
import 'package:moli_ai/core/utils/icon.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';

import '../../../data/models/conversation_model.dart';
import '../../../core/utils/color.dart';

class ConversationAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final ChatEntity currentChat;
  final VoidCallback onPressSetting;

  const ConversationAppBarWidget(
      {super.key, required this.currentChat, required this.onPressSetting});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      elevation: 4,
      automaticallyImplyLeading: false,
      // backgroundColor: colorScheme.primary,
      shadowColor: getShadowColor(colorScheme),
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  // color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              CircleAvatar(
                child: Icon(convertCodeToIconData(currentChat.icon)),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      currentChat.title,
                      style: const TextStyle(
                          // color: colorScheme.onPrimary,
                          fontSize: 14),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      currentChat.desc,
                      style: const TextStyle(
                          // color: colorScheme.onSecondary,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  onPressSetting();
                  // _navigateToConversationSettingScreen();
                },
                icon: const Icon(Icons.settings),
                // color: colorScheme.onSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
