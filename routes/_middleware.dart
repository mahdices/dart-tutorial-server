import 'package:dart_frog/dart_frog.dart';
import 'package:server/data/repository/post_datasource.dart';
import 'package:server/data/repository/user_datasource.dart';
import 'package:server/database.dart';
import 'package:server/error/not_font_exeption.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(injectionHandler()).use((handler) {
    return (context) async {
      try {
        final response = await handler(context);
        return response;
      } catch (e) {
        if (e is NotFoundExeption)
          return Response.json(body: e.response, statusCode: e.code);
        return Response.json();
      }
    };
  });
}

Middleware injectionHandler() {
  return (handler) {
    return handler
        .use(
          provider<UserDatasource>(
            (context) => UserDatasource(context.read<MySql>()),
          ),
        )
        .use(provider<PostDatasource>(
          (context) => PostDatasource(context.read<MySql>()),
        ));
  };
}
