import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_event.dart';
import 'package:realtime_chat_app/features/contact/presentation/bloc/contact_state.dart';
import 'package:realtime_chat_app/views/chat_screen.dart';

import '../features/contact/presentation/bloc/contact_bloc.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContactsBloc>(context).add(FetchContacts());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Contacts")),
        body: BlocListener<ContactsBloc, ContactsState>(
          listener: (context, state) async {
            final contactsBloc = BlocProvider.of<ContactsBloc>(context);
            if (state is ConversationReady) {
              var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChatScreen(
                        conversationId: state.conversationId,
                        mate: state.contact.username,
                        profileImage: state.contact.profileImage,
                      ),
                ),
              );
              if (res == null) {
                contactsBloc.add(FetchContacts());
              }
            }
          },
          child: BlocBuilder<ContactsBloc, ContactsState>(
            builder: (context, state) {
              if (state is ContactsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ContactsLoaded) {
                return ListView.builder(
                  itemCount: state.contacts.length,
                  itemBuilder: (context, index) {
                    final contact = state.contacts[index];
                    return ListTile(
                      title: Text(contact.username),
                      subtitle: Text(contact.email),
                      onTap: () {
                        // Navigator.pop(context, contact);
                        BlocProvider.of<ContactsBloc>(
                          context,
                        ).add(CheckOrCreateConversation(contact.id, contact));
                      },
                    );
                  },
                );
              } else if (state is ContactsError) {
                return Center(child: Text(state.message));
              }
              return Center(child: Text("No contacts found"));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showAddContactDialogBox(context);
          },
        ),
      ),
    );
  }

  void showAddContactDialogBox(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Contact"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(hint: Text("Enter contact email")),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  BlocProvider.of<ContactsBloc>(
                    context,
                  ).add(AddContact(email: email));
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
