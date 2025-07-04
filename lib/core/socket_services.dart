import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServices {
  static final SocketServices _instance = SocketServices._internal();

  factory SocketServices() => _instance;

  late IO.Socket _socket;
  final _storage = FlutterSecureStorage();

  SocketServices._internal() {
    initSocket();
  }

  Future<void> initSocket() async {
    String token = await _storage.read(key: 'token') ?? "";
    print("Token $token");
    _socket = IO.io(
      "http://192.168.1.35:4002",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({"Authorization": "Bearer $token"})
          .build(),
    );

    _socket.connect();
    _socket.onConnect((_) {
      print("Socket connected: ${_socket.id}");
    });

    _socket.onDisconnect((_) {
      print("Socket disconnected");
    });
  }

  IO.Socket get socket => _socket;
}
