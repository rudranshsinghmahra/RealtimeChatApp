import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realtime_chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:realtime_chat_app/features/chat/presentation/bloc/chat_state.dart';

import '../features/chat/presentation/bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.mate,
    required this.profileImage,
  });

  final String conversationId;
  final String mate;
  final String profileImage;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final storage = FlutterSecureStorage();
  String userId = '';
  String botId = '00000000-0000-0000-0000-000000000000';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatBloc>(
      context,
    ).add(LoadMessagesEvent(widget.conversationId));
    fetchUserId();
  }

  fetchUserId() async {
    userId = await storage.read(key: 'userId') ?? "";
    setState(() {
      userId = userId;
    });
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void sendMessage() {
    final content = messageController.text.trim();
    if (content.isNotEmpty) {
      BlocProvider.of<ChatBloc>(
        context,
      ).add(SendMessagesEvent(widget.conversationId, content));
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(widget.profileImage)),
              SizedBox(width: 10),
              Text(widget.mate),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoadedState) {
                    return ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isDailyQuestion = message.senderId == botId;
                        final isSentMessage = message.senderId == userId;
                        if (isSentMessage) {
                          return _buildSentMessage(context, message.content);
                        } else if (isDailyQuestion) {
                          return _buildDailyQuestionMessage(
                            context,
                            message.content,
                          );
                        } else {
                          return _buildReceivedMessage(
                            context,
                            message.content,
                          );
                        }
                      },
                    );
                  } else if (state is ChatErrorState) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text("No messages found"));
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade300,
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildDailyQuestionMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade300,
        ),
        child: Text("🧠 Daily Questions: $message"),
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade300,
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(Icons.camera_alt, color: Colors.grey),
            onTap: () {},
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Message",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 10),
          IconButton(onPressed: sendMessage, icon: Icon(Icons.send)),
        ],
      ),
    );
  }
}
