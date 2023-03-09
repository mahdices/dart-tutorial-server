import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:server/data/config.dart';
import 'package:server/data/repository/user_datasource.dart';

Future<Response> onRequest(RequestContext context) async {
  var body = await context.request.json();
  var username = body['username'] as String;
  var password = body['password'] as String;

  var data = context.read<UserDatasource>();
  var insertId = await data.addUser(
    username,
    DBCrypt().hashpw(password, DBCrypt().gensalt()),
  );
  final token =
      JWT({'username': username, 'id': insertId}).sign(SecretKey(secret));
  await data.updateUser(insertId, token);

  return Response.json(body: {'message': 'Created.'}, statusCode: 200);
}
