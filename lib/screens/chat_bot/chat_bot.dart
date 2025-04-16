import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_tour_planner/utilities/button/arrow_back_button.dart';

import '../../utilities/text/text_styles.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final Gemini gemini = Gemini.instance;

  ChatUser currentUser = ChatUser(id: "0", firstName: "User", profileImage: "assets/images/MTP_App_Icon.png");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Phoenix from MTP",
    profileImage: "assets/images/MTP_App_Icon.png",
  );

  List<ChatMessage> messages = [];
  bool showAllSuggestions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 157, 192, 1),
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ArrowBackButton(),
            Row(
              children: [
                Text(
                  "Chat with Phoenix by MTP",
                  style: TextStyle(fontFamily: "Sofia_Sans", color: Color.fromRGBO(254, 254, 254, 1)),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        Center(child: Opacity(opacity: 0.2,child: Image.asset("assets/images/MTP_App_Icon.png"))),
        DashChat(
          currentUser: currentUser,
          onSend: _sendMessage,
          messages: messages,
          messageOptions: MessageOptions(
            messageDecorationBuilder: (ChatMessage message, ChatMessage? prevMessage, ChatMessage? nextMessage) {
              if (message.user.id == currentUser.id) {
                return BoxDecoration(
                  color: const Color.fromRGBO(0, 157, 192, 1),
                  borderRadius: BorderRadius.circular(8),
                );
              }
              return BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              );
            },
            messageTextBuilder: (ChatMessage message, ChatMessage? _, ChatMessage? __) {
              if (message.user.id == geminiUser.id) {
                return MarkdownBody(
                  data: message.text,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: const TextStyle(fontSize: 14, fontFamily: 'Sofia_Sans'),
                  ),
                );
              }
              return Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Sofia_Sans',
                ),
              );
            },
          ),
        ),

        // Only show suggestions if no messages yet
        if (messages.isEmpty)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 50), // adjust as needed
                child: _buildSuggestions(),
              ),
            ),
          ),
      ],
    );
  }



  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;

      gemini.streamGenerateContent(question).listen((event) {
        String response = event.content?.parts
                ?.whereType<TextPart>()
                .map((e) => e.text)
                .join(" ") ??
            "";

        ChatMessage? lastMessage = messages.isNotEmpty ? messages.first : null;

        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Widget _buildSuggestions() {
    final allSuggestions = [
      "Plan a 2-day trip to Ahmedabad",
      "Find hidden gems in Gujarat",
      "What's the best time to visit Chennai?",
      "Suggest a weekend getaway near me",
      "Help me pack for a mountain trek",
      "Create a travel itinerary for Goa",
      "How can I travel on a budget?",
      "Translate useful phrases for Maharashtra",
    ];

    final displayedSuggestions = showAllSuggestions
        ? allSuggestions
        : allSuggestions.take(4).toList();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: [
        ...displayedSuggestions.map((text) {
          return ActionChip(
            label: Text(text, style: const TextStyle(fontSize: 13)),
            backgroundColor: const Color.fromRGBO(0, 157, 192, 0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              final msg = ChatMessage(
                user: currentUser,
                createdAt: DateTime.now(),
                text: text,
              );
              _sendMessage(msg);
            },
          );
        }),
        if (!showAllSuggestions)
          ActionChip(
            label: const Text("More", style: TextStyle(fontSize: 13)),
            backgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              setState(() {
                showAllSuggestions = true;
              });
            },
          ),
      ],
    );
  }

}
