import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController extends GetxController {
  var titles = <String>[].obs;
  var data = <String>[].obs;
  late Database database;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeDatabase();
    fetchDatabase();
  }

  Future<void> initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'my_database.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print("ENTERED");
        await db.execute('''
          CREATE TABLE data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT
          )
      ''');

        await db.execute('''
        CREATE TABLE titles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          value INTEGER
        )
      ''');
      },
    );
  }

  Future<void> insertTitle(String value) async {
    await database.insert(
      'titles',
      {'text': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertData(String value) async {
    await database.insert(
      'data',
      {'text': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> getAllTableNames() async {
    List<Map<String, dynamic>> tables = await database.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

    List<String> tableNames = [];
    for (var table in tables) {
      tableNames.add(table['name']);
    }
    print("ALL the tables here: $tableNames");
  }


  Future<void> printDatabaseContent() async {
    List<Map<String, dynamic>> rowsTitles = await database.query('titles');
    List<Map<String, dynamic>> rowsData = await database.query('data');

    for (var row in rowsTitles) {
      print('Titles content ID: ${row['id']}, Text: ${row['text']}');
    }

    for (var row in rowsData) {
      print('Data content ID: ${row['id']}, Text: ${row['text']}');
    }
  }

  Future<void> clearDataAndTitles() async {
    await database.delete('data');
    await database.delete('titles');
    print('Data cleared from the table.');
  }

  Future<void> createTable(String tableName, List<String> columns) async {
    await database.execute('''
    CREATE TABLE $tableName (
      ${columns.join(', ')}
    )
  ''');
  }

  Future<void> deleteTable(String tableName) async {
    await database.execute('DROP TABLE IF EXISTS $tableName');
  }

  Future<void> fetchDatabase() async {
    List<Map<String, dynamic>> rowsTitles = await database.query('titles');
    List<Map<String, dynamic>> rowsData = await database.query('data');

    for (var row in rowsTitles) {
      titles.add(row['text']);
    }

    for (var row in rowsData) {
      data.add(row['text']);
    }
    update();
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

      /*await clearDataAndTitles();
      await insertTitle(title);
      await insertData(value);
      await printDatabaseContent();
      await getAllTableNames();*/
    }

    await insertTitle(title);
    await insertData(value);
    await printDatabaseContent();

    update();
  }
}
