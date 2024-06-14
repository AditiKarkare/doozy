import 'package:doozy/view/chatBot/widget.dart';
import 'package:flutter/material.dart';

class BotErrorMessageCard extends StatefulWidget {
  final String text;
  const BotErrorMessageCard({super.key, required this.text});

  @override
  State<BotErrorMessageCard> createState() => _BotErrorMessageCardState();
}

class _BotErrorMessageCardState extends State<BotErrorMessageCard> {
  @override
  Widget build(BuildContext context) {
    return chatTile(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Text(widget.text),
    ));
  }
}
