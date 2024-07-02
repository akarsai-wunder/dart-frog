import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:todos_data_source/todos_data_source.dart';

class DatabaseService {
  static final db = Db("mongodb://localhost:27017/todos");
  //start the database
  static Future<void> startDb() async {
    if (db.isConnected == false) {
      await db.open();
    }
  }

  //close the database
  static Future<void> closeDb() async {
    if (db.isConnected == true) {
      await db.close();
    }
  }

  //collections
  static final todosCollections = db.collection('todos');

  // we will use this method to start the database connection and use it in our routes
  Future<Response> startConnection(
      RequestContext context,
      Future<Response> callBack,
      ) async {
    try {
      await startDb();
      return await callBack;
    } catch (e) {
      print(e.toString());
      return Response.json(
        statusCode: 500,
        body: {'message': 'Internal server error'},
      );
    }
  }

  Future<List<Todo>> getAll() async{
    final docs = await todosCollections.find().toList();
    final todos = docs.map(Todo.fromJson).toList();
    return todos;
  }

  Future<Todo?> getOne(String id) async{
    final doc = await todosCollections.findOne(where.eq('id', id));
    if(doc != null)
      return Todo.fromJson(doc);

    return null;
  }

  Future<Todo> create(Todo todo) async{
    await todosCollections.insert(todo.toJson());
    return todo;
  }

  Future<Todo> update(String id, Todo todo) async{
    await todosCollections.update(where.eq('id', id), todo.toJson());
    return todo;
  }

  Future<void> delete(String id) async{
    await todosCollections.deleteOne(where.eq('id', id));
  }
}