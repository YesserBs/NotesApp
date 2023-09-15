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
    await fetchDatabase();
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

  Future<void> insertData(int id, String title, String content, bool changeTitle, bool changeContent, bool change) async {
    print("HERE parameters $change $changeTitle $changeContent");
    if (change){
      if (changeTitle || changeContent){
        if (!changeTitle && changeContent){
          await database.update(
            'data',
            {'title': title},
            where: 'id = ?',
            whereArgs: [id],
          );
        }
        else if (!changeContent && changeTitle){
          await database.update(
            'data',
            {'content': content},
            where: 'id = ?',
            whereArgs: [id],
          );
        }
      }
      else{
        await database.update(
          'data',
          {'title': title, 'content': content},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }
    else{
      print("Entred ALSO");
      await database.insert(
        'data',
        {'id': id, 'title': title, 'content': content},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteItem(int id) async {
    print("Entered and here is data ${data.value}");
    // Deleting from data list
    data.removeAt(id);
    // Deleting from database
    await database.delete(
      'data',
      where: 'id = ?',
      whereArgs: [id],
    );
    // Update IDs in the range [id + 1, maxId]
    for (int i = id + 1; i <= data.value.length; i++) {
      await database.update(
        'data',
        {'id': i - 1},
        where: 'id = ?',
        whereArgs: [i],
      );
    }


    print("Entered and here is data ${data.value}");
    await printDatabaseContent();
    update();
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
    print("Entered");

    for (var row in rowsData) {
      print('Data content ID: ${row['id']}, title ${row['title']}, content: ${row['content']}');
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
    bool change = false;
    int id = data.value.length;
    if (index != -1) {
      change = true;
      id = index;
      if (changeTitle == false) {
        data[index]['title'] = title;
      }
      if (changeContent == false) {
        data[index]['content'] = content;
      }
    } else {
      data.add({'title': title, 'content': content});
    }

    //await deleteTable("data");
    //await createTable("data", ["id INTEGER", "title TEXT", "content TEXT"]);

    //await insertData(title, content);
    //await clearDataAndTitles();
    await insertData(id, title, content, changeTitle, changeContent, change);
    await getAllTableNames();
    await printDatabaseContent();

    update();
  }
}
