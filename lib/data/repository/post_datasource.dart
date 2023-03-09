import 'package:server/data/models/post.dart';
import 'package:server/data/models/user.dart';
import 'package:server/database.dart';

class PostDatasource {
  PostDatasource(this._mysqlClient);
  final MySql _mysqlClient;

  Future<List<Post>> getPosts() async {
    final result = await _mysqlClient.execute(
        'SELECT posts.id, users.username, posts.message, posts.date FROM posts INNER JOIN users ON users.id=posts.ownerId;');
    if (result.isEmpty) return Future.error('NotFound');
    final list = <Post>[];
    for (final row in result) {
      list.add(Post.fromRow(row));
    }
    return list;
  }

  Future<bool> addPost(int ownerId, String message, String date) async {
    final result = await _mysqlClient.execute(
      'INSERT INTO posts(ownerId, message, date) VALUES (? , ?, ?);',
      params: [
        ownerId,
        message,
        date,
      ],
    );

    if (result.insertId == null) return Future.error("Error");

    return true;
  }
}
