import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController extends GetxController {
  var titles = <String>[].obs;
  var data = <String>[].obs;
  late Database database;

  void onInit() {
    super.onInit();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    // Get a reference to the database path
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'my_database.db');

    // Open the database or create it if it doesn't exist
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the table
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
    // Get a reference to the database
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'my_database.db');
    Database database = await openDatabase(path);

    // Insert the text into the 'data' table
    await database.insert(
      'data', // Use the correct table name here
      {'text': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> printDatabaseContent() async {
    // Get a reference to the database
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'my_database.db');
    Database database = await openDatabase(path);

    // Query the database to retrieve all rows from the 'data' table
    List<Map<String, dynamic>> rows = await database.query('data');

    // Print the content of each row
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
      addTextToDatabase(value);
      printDatabaseContent();
    }
    update();
  }
}
