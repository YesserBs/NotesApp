import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController extends GetxController {
  var data = <Map<String, String>>[].obs;
  var filtredData = <Map<String, String>>[].obs;
  String searchedText = "";
  late Database database;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeDatabase();
    fetchDatabase();
  }

  void getSearchText(String value) {
    searchedText = value;
    filterTitles(value);
  }


  void filterTitles(String value) {
    if (value.isEmpty) {
      filtredData.value = data.value; // Show all articles if value is empty
    } else {
      filtredData.value = data.value
          .where((instance) => instance["title"]!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    print("Here the filtred titles and DATA $filtredData $filtredData");
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

  Future<void> insertData(String title, String content) async {
    await database.insert(
      'data',
      {'title': title, 'content': content},
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
    List<Map<String, dynamic>> rowsData = await database.query('data');

    for (var row in rowsData) {
      print('Data content ID: ${row['id']}, Text: ${row['text']}');
    }
  }

  Future<void> clearDataAndTitles() async {
    await database.delete('data');
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
    List<Map<String, dynamic>> rowsData = await database.query('data');

    for (var row in rowsData) {
      data.add({
        'title': row['title'],
        'content': row['content'],
      });
    }
    filtredData.value = data.value;
    update();
  }

  void save(
      String title,
      bool changeTitle,
      String content,
      bool changeContent,
      int index,
      ) async {
    if (index != -1) {
      if (changeTitle == false) {
        data[index]['title'] = title;
      }
      if (changeContent == false) {
        data[index]['content'] = content;
      }
    } else {
      data.add({'title': title, 'content': content});
    }

    await insertData(title, content);

    update();
  }
}
