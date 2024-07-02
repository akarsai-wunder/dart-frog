import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:todos_data_source/todos_data_source.dart';

import '../../packages/mongo/database_services.dart';

late DatabaseService dataSource;

FutureOr<Response> onRequest(RequestContext context) async {
  dataSource = context.read<DatabaseService>();
  switch (context.request.method) {
    case HttpMethod.get:
      return dataSource.startConnection(context, _get(context));
    case HttpMethod.post:
      return dataSource.startConnection(context, _post(context));
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final todos = await dataSource.getAll();
  return Response.json(body: todos);
}

Future<Response> _post(RequestContext context) async {
  final todo = Todo.fromJson(
    await context.request.json() as Map<String, dynamic>,
  );

  return Response.json(
    statusCode: HttpStatus.created,
    body: await dataSource.create(todo),
  );
}

