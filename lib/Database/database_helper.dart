import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';
import '../models/car.dart';
import '../models/repair.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'car_diary.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cars (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        registration_number TEXT,
        fuel_consumption REAL,
        last_oil_change_date TEXT,
        last_oil_change_km INTEGER,
        insurance_due_date TEXT,
        vignette_due_date TEXT,
        technical_due_date TEXT,
        total_spent REAL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE repairs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        car_id INTEGER,
        description TEXT,
        cost REAL,
        date TEXT,
        FOREIGN KEY (car_id) REFERENCES cars(id)
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<int> insertCar(Car car) async {
    final db = await database;
    return await db.insert('cars', car.toMap());
  }

  Future<List<Car>> getCarsByUser(int userId) async {
    final db = await database;
    final result = await db.query('cars', where: 'user_id = ?', whereArgs: [userId]);
    return result.map((e) => Car.fromMap(e)).toList();
  }

  Future<int> insertRepair(Repair repair) async {
    final db = await database;
    return await db.insert('repairs', repair.toMap());
  }

  Future<List<Repair>> getRepairsByCar(int carId) async {
    final db = await database;
    final result = await db.query('repairs', where: 'car_id = ?', whereArgs: [carId]);
    return result.map((e) => Repair.fromMap(e)).toList();
  }

  Future<int> deleteRepair(int id) async {
    final db = await database;
    return await db.delete('repairs', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateRepair(Repair repair) async {
    final db = await database;
    return await db.update('repairs', repair.toMap(), where: 'id = ?', whereArgs: [repair.id]);
  }
}
