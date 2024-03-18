import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketDemo extends StatefulWidget {
  const SocketDemo({Key? key}) : super(key: key);

  @override
  State<SocketDemo> createState() => _SocketDemoState();
}

class _SocketDemoState extends State<SocketDemo> {
  late TextEditingController _textEditingController;
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _channel =
        IOWebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));
  }

  _connectSocketChannel() {
    _channel =
        IOWebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));
  }

  void sendMessage() {
    _channel.sink.add(_textEditingController.text);
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Demo'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white60,
                  contentPadding: EdgeInsets.all(15.0),
                  hintText: 'Message',
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  if (_textEditingController.text.isEmpty) {
                    return;
                  }
                  sendMessage();
                },
                child: const Text('Send Message'),
              ),
              StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
