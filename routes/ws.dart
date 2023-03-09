import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:server/data/config.dart';
import 'package:server/data/models/chat.dart';
import 'package:server/data/models/user.dart';

import '../main.dart';

Future<Response> onRequest(RequestContext context) async {
  print("A request");
  final url = context.request.url.toString();
  final token = url.substring(url.indexOf('token=') + 6);

  final jwt = JWT.verify(token, SecretKey(secret));

  final handler = webSocketHandler(
    (channel, protocol) {
      final user = User(jwt.payload['id'] as int,
          jwt.payload['username'] as String, null, null);

      chats.add(Chat(user: user, channel: channel));

      channel.stream.listen(
        (message) {
          for (final chat in chats) {
            if (chat.user == user) continue;
            chat.channel.sink.add(message);
          }
        },
        onDone: () {
          chats.removeWhere((element) => element.user.id == user.id);
        },
      );
    },
  );

  return handler(context);
}
