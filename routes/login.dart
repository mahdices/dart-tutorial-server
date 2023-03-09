import 'package:dart_frog/dart_frog.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:server/data/repository/user_datasource.dart';

Future<Response> onRequest(RequestContext context) async {
  var body = await context.request.json();
  var username = body['username'] as String;
  var password = body['password'] as String;

  print(username);
  print(password);

  var data = context.read<UserDatasource>();
  var user = await data.getUser(username);
  final isPasswordCorrect = DBCrypt().checkpw(password, user.password ?? '');
  if (isPasswordCorrect) {
    return Response.json(body: user.toJson(), statusCode: 200);
  }
  return Response.json(body: 'Error', statusCode: 403);
}
