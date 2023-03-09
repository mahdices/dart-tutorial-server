import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:server/data/config.dart';
import 'package:server/data/repository/post_datasource.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) return createPost(context);
  if (context.request.method == HttpMethod.get) return getPosts(context);

  return Response.json(body: 'Error', statusCode: 403);
}

Future<Response> createPost(RequestContext context) async {
  var json = await context.request.json();
  var date = DateTime.now();
  final auth = context.request.headers['Authorization'];
  if (auth == null) return Response.json();
  final user = JWT.verify(auth.split(' ')[1], SecretKey(secret));

  var data = context.read<PostDatasource>().addPost(
        user.payload['id'] as int,
        json['message'] as String,
        date.toIso8601String(),
      );
  return Response.json(body: {'message': 'Created.'}, statusCode: 200);
}

Future<Response> getPosts(RequestContext context) async {
  var data = await context.read<PostDatasource>().getPosts();
  final result = [];
  for (final post in data) {
    result.add(post.toJson());
  }
  return Response.json(body: result, statusCode: 200);
}
