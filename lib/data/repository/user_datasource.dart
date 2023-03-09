import 'dart:io';

import 'package:server/data/models/user.dart';
import 'package:server/database.dart';
import 'package:server/error/not_font_exeption.dart';

class UserDatasource {
  UserDatasource(this._mysqlClient);
  final MySql _mysqlClient;

  Future<User> getUser(String username) async {
    final result = await _mysqlClient.execute(
        'SELECT id, username, password, token FROM users WHERE username=?;',
        params: [username]);
    if (result.isEmpty) throw NotFoundExeption('User not found', 404);
    final user = User.fromRow(result.first);
    return user;
  }

  Future<void> updateUser(int id, String token) async {
    final result = await _mysqlClient
        .execute('UPDATE users set token=? WHERE id=?;', params: [token, id]);
  }

  Future<int> addUser(String username, String password) async {
    final result = await _mysqlClient.execute(
        'INSERT INTO users(username, password) VALUES (?,?);',
        params: [username, password]);

    if (result.insertId == null) return Future.error("Error");

    return result.insertId!;
  }
}
