import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_app/models/user.dart';

/* responsable for creating tables and all operation in db (CRUD)
if i hv class then need to create mulitiple instance or object to use it and 
everytime we create instance it will save in momorey instaed of doing that
we create one instance inside this class that mean when we invoke DatabaseHelper() class
we don't need to create instance everytime we create only one instance that will be aprt of entir application
.. in echa app we need just one databasehelper not everytime create a new one
*/

class DatabaseHelper {
// instance of class / (internal) can be any name but internal means insied this class
  static final DatabaseHelper _instance = DatabaseHelper.internal();

// constractor allow us to cache all state of this databasehlepr class
// make sure everytime we invoke this class we not creatin alot of object
// return _instance
  factory DatabaseHelper() => _instance;

  final String tableUser = "userTable";
  final String columnId = "id";
  final String columnUsername = "username";
  final String columnPassword = "password";

  static Database _db;

  // here to we make sure that we don't creata instance evrytime we invoke this class
  // if there is a db return it then initilaize it
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

// constractour(internal) privet to this class
  DatabaseHelper.internal();

// create database
// get the path first
// .path give us the string (home/dirctory/file/maindb.db)
// next time we updata database put version 2 or something like that
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentDirectory.path, "maindb.db"); //home://directory/files/maindb.db

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  // create our table
  // wriet sql commend in execute method

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $columnUsername TEXT, $columnPassword TEXT)");
  }

//CRUD



/* insert
wehn we insert anythin in db it return intger 1/0 (1 correct /o wrong)
 pass User type / user object we created
create instance of db
int res= await dbClient.insert(table, values) // int bc when data returns it return as number 1 / 0
insert (tablename,value  of usernam and password / User  user object type do that)
user is object from User class then invoke tomap method it set values for unsername and password
*/

  Future<int> saveUser(User user) async {
    var dbClient = await db;

    int res = await dbClient.insert("$tableUser", user.toMap());
    return res;
  }

/* Get All Users
 * Future expected List bc will get all user in database
 * 
 */

  Future<List> getAllUser() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser");
    return result.toList();
  }

/* Get the count of our table 
 * how many user we have
 *     var dbClient = await db; instance of our db
 */

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser"));
  }

/*GEt One User
 *  the best way to get one user to use Column ID
 * check if result.lenght = 0 retun null
 * User.fromMap(result.first); the key is gonna be username value will be data in it (name) the other key be password then value in int
 */

  Future<User> getUser(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableUser WHERE $columnId =$id");
    if (result.length == 0) return null;
    return User.fromMap(result.first);
  }

/**DELETE one USER
 * 
 * where:"$columnId= ?" means we don't know what but whereArgs: [id] here we will know
 * 
 */

  Future<int> deleteUser(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(tableUser, where: "$columnId= ?", whereArgs: [id]);
  // we could put if satamen here if return 1 deleted susseccful else something happedn
  }

/** UPDATE 
 * 
 * 
 */

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(tableUser,
     user.toMap(), where: "$columnId = ?", whereArgs: [user.id]);
  }
/** CLOSE DATABASE
 * 
 */

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
