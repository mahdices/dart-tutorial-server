import 'package:mysql1/mysql1.dart';

class MySql {
  MySqlConnection? _connection;

  factory MySql() {
    return _inst;
  }
  MySql._internal() {
    _connect();
  }
  static final MySql _inst = MySql._internal();

  Future<void> _connect() async {
    final setting = ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      password: '12345678',
      db: 'test',
    );
    _connection = await MySqlConnection.connect(setting);
  }

  Future<Results> execute(
    String query, {
    List<Object>? params,
  }) async {
    if (_connection == null) {
      await _connect();
    }
    return _connection!.query(query, params);
  }
}
