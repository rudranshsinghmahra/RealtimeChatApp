import 'package:flutter/cupertino.dart';
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
  final ScrollController _scrollController = ScrollController();


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
    _scrollController.dispose();
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
    return Container(
      color: Color(0xffffecc6),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffffecc6), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: AppBar(
                title: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xffbf6847), width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(widget.profileImage),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(widget.mate, style: TextStyle(fontSize: 18)),
                  ],
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 30),
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ChatLoadedState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xfffeecc2),
                          borderRadius: BorderRadius.all(
                              Radius.circular(30)
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: state.messages.length,
                                itemBuilder: (context, index) {
                                  final message = state.messages[index];
                                  final isDailyQuestion =
                                      message.senderId == botId;
                                  final isSentMessage =
                                      message.senderId == userId;
                                  if (isSentMessage) {
                                    return _buildSentMessage(
                                      context,
                                      message.content,
                                    );
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
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
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
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 15, top: 3, bottom: 3),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Color(0xffffffff)),
        child: Text(message, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(right: 15, top: 3, bottom: 3),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: Color(0xff333333),
        ),
        child: Text(message, style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              controller: messageController,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                prefixText: "   ",
                suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                    ), child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        CupertinoIcons.mic, color: Colors.black, size: 20,),
                    ))),
                filled: true,
                fillColor: Color(0xff000000),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: "Type something....",
                hintStyle: TextStyle(color: Colors.white),

              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          Container(decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                Color(0xffde5109), Color(0xff9a3c10),
              ],)
          ),
              child: IconButton(onPressed: sendMessage,
                  icon: Icon(CupertinoIcons.forward, color: Colors.white))),
        ],
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
