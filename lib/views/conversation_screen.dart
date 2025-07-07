import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_state.dart';
import 'package:realtime_chat_app/features/conversations/domain/entities/conversation_entity.dart';
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
    return Container(
      color: Color(0xffffecc6),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
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
                title: Text("Messages"),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xffdfb090),
                            width: 1.5),
                        gradient: LinearGradient(colors: [
                          Color(0xfffeefd9),
                          Color(0xfffee0ca)
                        ],)
                    ),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search, color: Colors.black))),
                  ),
                ],
              ),
            ),
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
                                          profileImage:
                                          recentContacts.profileImage,
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
                    color: Color(0xffffefd1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                return _buildMessageTile(
                                  conversation.participantName,
                                  conversation.participantImage,
                                  conversation.lastMessage,
                                  conversation.lastMessageTime.toString(),
                                  conversation,
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
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xffd24d0f),
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
            child: Icon(Icons.contacts, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTile(String name,
      String participantImage,
      String message,
      String time, ConversationEntity conversation) {
    final dateTime = DateTime.parse(time);
    final formattedTime = DateFormat.jm().format(dateTime);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                ChatScreen(
                  conversationId: conversation.id,
                  mate: conversation
                      .participantName,
                  profileImage:
                  conversation.participantImage,
                ),
          ),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 18, bottom: 15),
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xffdec5b4),
                      width: 3, // Border width
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(participantImage),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        message,
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                    formattedTime, style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: List.generate(1000 ~/ 10, (index) =>
                  Expanded(
                    child: Container(
                      color: index % 2 == 0 ? Colors.transparent
                          : Color(0xffdb8f6d),
                      height: 1,
                    ),
                  )),
            ),
          ),
        ],
      ),
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
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Color(0xffdec5b4),
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(profileImage),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(name),
        ],
      ),
    );
  }
}
