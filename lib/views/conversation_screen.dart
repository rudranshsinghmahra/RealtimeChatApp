import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_state.dart';
import 'package:realtime_chat_app/views/chat_screen.dart';

import '../features/contact/presentation/bloc/contact_event.dart';
import '../features/conversations/presentation/bloc/conversation_bloc.dart';
import '../features/conversations/presentation/bloc/conversation_event.dart';
import '../features/conversations/presentation/bloc/conversation_state.dart';
import 'contact_screen.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context).add(FetchConversation());
    BlocProvider.of<ContactsBloc>(context).add(LoadRecentContact());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: BlocBuilder<ContactsBloc, ContactsState>(
                builder: (context, state) {
                  if (state is RecentContactLoaded) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.recentContacts.length,
                      itemBuilder: (context, index) {
                        final recentContacts = state.recentContacts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                    ChatScreen(
                                      conversationId: recentContacts.id,
                                      mate: recentContacts.username,
                                      profileImage: recentContacts.profileImage,
                                    ),
                              ),
                            );
                          },
                          child: _buildRecentContact(
                            name: recentContacts.username,
                            profileImage: recentContacts.profileImage,
                          ),
                        );
                      },
                    );
                  } else if (state is ContactsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ContactsError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text("No recent contact found"));
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if (state is ConversationLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ConversationLoaded) {
                    return ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = state.conversations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChatScreen(
                                      conversationId: conversation.id,
                                      mate: conversation.participantName,
                                      profileImage:
                                      conversation.participantImage,
                                    ),
                              ),
                            );
                          },
                          child: _buildMessageTile(
                            conversation.participantName,
                            conversation.participantImage,
                            conversation.lastMessage,
                            conversation.lastMessageTime.toString(),
                          ),
                        );
                      },
                    );
                  } else if (state is ConversationError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text("No conversations found"));
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final contactBloc = BlocProvider.of<ContactsBloc>(context);
          var res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactScreen()),
          );
          if (res == null) {
            contactBloc.add(LoadRecentContact());
          }
        },
        child: Icon(Icons.contacts),
      ),
    );
  }

  Widget _buildMessageTile(String name,
      String participantImage,
      String message,
      String time,) {
    final dateTime = DateTime.parse(time);
    final formattedTime = DateFormat.jm().format(dateTime);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(participantImage),
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        message,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: Text(formattedTime, style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildRecentContact({
    required String name,
    required String profileImage,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(profileImage),
          ),
          SizedBox(height: 5),
          Text(name),
        ],
      ),
    );
  }
}
