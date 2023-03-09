import 'package:mysql1/mysql1.dart';

class Post {
  Post(this.id, this.owner, this.message, this.dateTime);
  factory Post.fromRow(ResultRow json) {
    return Post(
      json[0] as int,
      json[1] as String,
      json[2] as String,
      (json[3] as DateTime).toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'owner': owner,
      'date': dateTime,
    };
  }

  final int id;
  final String owner;
  final String message;
  final String dateTime;
}
