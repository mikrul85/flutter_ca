import 'package:ca_example/data/models/user/address/address_model.dart';
import 'package:ca_example/data/models/user/company/company_model.dart';
import 'package:ca_example/data/models/user/user_model.dart';
import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'user_sqlite_api.g.dart';

// "Это сгенерирует для нас таблицу с именем "UserTable".
class UserTable extends Table {
  IntColumn get id => integer()();
  TextColumn get username => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get phone => text()();
  TextColumn get website => text()();
  TextColumn get company => text().map(const CompanyConverter()).nullable()();
  TextColumn get address => text().map(const AddressConverter()).nullable()();
}

class PostsTable extends Table {
  IntColumn get id => integer()();
  IntColumn get userId => integer().references(UserTable, #id)();
  TextColumn get title => text()();
  TextColumn get body => text()();
}

// эта аннотация говорит дрифт подготовить класс базы данных, который использует три
// таблицы, которые мы только что определили
@DriftDatabase(tables: [UserTable, PostsTable])
class MyDatabase extends _$MyDatabase {
  // мы сообщаем базе данных, где хранить данные с помощью этого конструктора
  // MyDatabase() : super(_openConnection());
  static MyDatabase sqlDB = MyDatabase._();
  MyDatabase._() : super(_openConnection());

  // нужно увеличивать это число всякий раз, когда мы изменяем или добавляем определение таблицы.
  @override
  int get schemaVersion => 1;
}

/// Инициализируем БД Sqlite
LazyDatabase _openConnection() {
  // утилита LazyDatabase позволяет нам найти правильное место для файла async.
  return LazyDatabase(() async {
    // поместим файл базы данных, названный здесь db.sqlite, в папку документов
    // для нашего приложения.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

/// Класс Api для Sqlite
class UserSqliteApi {
  MyDatabase sqlDB = MyDatabase.sqlDB;

  UserTableData userToUserTable(User user) {
    return UserTableData.fromJson(user.toJson());
  }

  User userFromUserTable(UserTableData userTable) {
    return const UserConverter().fromSql(userTable.toJsonString());
  }

  Future<void> setUsers(List<User> listUsers) async {
    await Future.forEach(listUsers, (e) async {
      int insertIndex =
          await sqlDB.into(sqlDB.userTable).insert(userToUserTable(e));
    });
  }

  Future<List<User>> getUsersFromSql() async {
    List<UserTableData> listUserTable =
        await sqlDB.select(sqlDB.userTable).get();
    return listUserTable.map((e) => userFromUserTable(e)).toList();
  }

  Future<void> clearDB() async {
    await sqlDB.customStatement('PRAGMA foreign_keys = OFF');
    try {
      sqlDB.transaction(() async {
        for (final table in sqlDB.allTables) {
          await sqlDB.delete(table).go();
        }
      });
    } finally {
      await sqlDB.customStatement('PRAGMA foreign_keys = OFF');
    }
  }

  deleteDB() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    file.delete();
  }
}
