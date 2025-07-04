import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realtime_chat_app/core/socket_services.dart';
import 'package:realtime_chat_app/features/chat/domain/entity/message_entity.dart';
import 'package:realtime_chat_app/features/chat/domain/usecases/fetchMessageUseCase.dart';
import 'package:realtime_chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:realtime_chat_app/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessageUseCase fetchMessageUseCase;
  final SocketServices _socketServices = SocketServices();
  final List<MessageEntity> _messages = [];
  final _storage = FlutterSecureStorage();

  ChatBloc(this.fetchMessageUseCase) : super(ChatLoadingState()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessagesEvent>(_onSendMessages);
    on<ReceiveMessagesEvent>(_onReceiveMessages);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoadingState());
    try {
      final messages = await fetchMessageUseCase(event.conversationId);
      _messages.clear();
      _messages.addAll(messages);
      emit(ChatLoadedState(List.from(_messages)));

      print("Socket connected: ${_socketServices.socket.connected}");
      _socketServices.socket.emit('joinConversation', event.conversationId);

      _socketServices.socket.off('newMessage');
      _socketServices.socket.on('newMessage', (data) {
        print("Step 1 - receive : $data");
        add(ReceiveMessagesEvent(data));
      });
    } catch (error) {
      emit(ChatErrorState("Failed to load messages $error"));
    }
  }

  // Future<void> _onLoadMessages(
  //     LoadMessagesEvent event,
  //     Emitter<ChatState> emit,
  //     ) async {
  //   emit(ChatLoadingState());
  //
  //   try {
  //     final messages = await fetchMessageUseCase(event.conversationId);
  //     _messages.clear();
  //     _messages.addAll(messages);
  //     emit(ChatLoadedState(List.from(_messages)));
  //
  //     // Wait until socket is connected before emitting
  //     Timer.periodic(Duration(milliseconds: 300), (timer) {
  //       if (_socketServices.socket.connected) {
  //         timer.cancel();
  //         print("✅ Socket connected, joining room");
  //
  //         _socketServices.socket.emit('joinConversation', event.conversationId);
  //
  //         _socketServices.socket.on('newMessage', (data) {
  //           print("📩 newMessage received: $data");
  //           add(ReceiveMessagesEvent(data));
  //         });
  //       } else {
  //         print("⌛ Waiting for socket to connect...");
  //       }
  //     });
  //   } catch (error) {
  //     emit(ChatErrorState("Failed to load messages"));
  //   }
  // }

  Future<void> _onSendMessages(
    SendMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    String userId = await _storage.read(key: 'userId') ?? '';
    print('userId : $userId');

    final newMessage = {
      'conversationId': event.conversationId,
      'content': event.content,
      'senderId': userId,
    };
    _socketServices.socket.emit('sendMessage', newMessage);
  }

  Future<void> _onReceiveMessages(
    ReceiveMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    print("Step 2 - Receive event called");
    print(event.message);
    final message = MessageEntity(
      id: event.message['id'],
      conversationId: event.message['conversation_id'],
      senderId: event.message['sender_id'],
      content: event.message['content'],
      createdAt: event.message['created_at'],
    );
    _messages.add(message);
    emit(ChatLoadedState(List.from(_messages)));
  }
}
