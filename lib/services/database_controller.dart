import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController extends GetxController {
  var titles = <String>[].obs;
  var data = <String>[].obs;
  late Database database;

  @override
  void onInit() {
    super.onInit();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'my_database.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE data (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          text TEXT
        )
      ''');
      },
    );
  }

  Future<void> addTextToDatabase(String value) async {
    await database.insert(
      'data',
      {'text': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> printDatabaseContent() async {
    List<Map<String, dynamic>> rows = await database.query('data');

    for (var row in rows) {
      print('ID: ${row['id']}, Text: ${row['text']}');
    }
  }

  void save(String title, bool changeTitle, String value, bool changeData, int index, bool wasEmpty) async {
    if (index != -1) {
      if (changeTitle == false) {
        titles[index] = title;
      }
      if (changeData == false) {
        data[index] = value;
      }
    } else {
      titles.add(title);
      data.add(value);
      await addTextToDatabase(value);
      await printDatabaseContent();
    }
    update();
  }
}
