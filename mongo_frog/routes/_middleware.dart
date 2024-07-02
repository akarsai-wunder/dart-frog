import 'package:dart_frog/dart_frog.dart';

import '../packages/mongo/database_services.dart';

final _dataSource = DatabaseService();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<DatabaseService>((_) => _dataSource));
}