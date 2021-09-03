//@dart=2.9
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database() async {
    final dbPath = sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath.toString(), 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id Text PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm
          .replace, // this is used to overwrite on the data, if same those have same id.
    );
  }

  //we are getting these future data "Future<List<Map<String, dynamic>>>"  from query().
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
