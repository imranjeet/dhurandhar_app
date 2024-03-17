// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// import '../utils/custom_logger.dart';

// //
// class DBService {
//   final String _dbName = "test1.db";
//   late Database _db;

//   Database get db => _db;

//   Future open() async {
//     var databasesPath = await getDatabasesPath();
//     var path = join(databasesPath, _dbName);

//     // Make sure the directory exists , creating one , if doesn't exists.
//     try {
//       await Directory(databasesPath).create(recursive: true);
//     } catch (_) {}
//     // open the database
//     _db = await openDatabase(path, version: 2,
//         onUpgrade: (Database db, int version, int newVersion) async {
//       await createDb(db, newVersion);
//     }, onCreate: (Database db, int version) async {
//       await createDb(db, version);
//     }, onOpen: (Database db) async {});
//   }

//   Future createDb(Database db, int version) async {
//     try {
//       CustomLogger.instance.singleLine('created');
//       //Creating for recent search places
//       await db.execute('''      
//         DROP TABLE IF EXISTS recentPlaces;
//         ''');

//       await db.execute('''
//         CREATE TABLE recentPlaces
//         (id TEXT NOT NULL PRIMARY KEY,
//         placeName TEXT NOT NULL
//         );
//         ''');
//     } catch (er) {
//       CustomLogger.instance.singleLine(er.toString());
//     }
//   }
// }
