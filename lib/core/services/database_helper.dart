import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('home_rental.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    // Table 1: Properties
    await db.execute('''
      CREATE TABLE properties (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        floors INTEGER NOT NULL,
        totalSize REAL NOT NULL,
        yearBuilt INTEGER NOT NULL,
        imageUrl TEXT
      )
    ''');

    // Table 2: Units
    await db.execute('''
      CREATE TABLE units (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        propertyId INTEGER NOT NULL,
        unitNumber TEXT NOT NULL,
        rentAmount REAL NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (propertyId) REFERENCES properties (id) ON DELETE CASCADE
      )
    ''');

    // Table 3: Tenants
    await db.execute('''
      CREATE TABLE tenants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        nid TEXT NOT NULL,
        propertyId INTEGER NOT NULL,
        unitId INTEGER NOT NULL,
        leaseStart TEXT NOT NULL,
        leaseEnd TEXT NOT NULL,
        rentAmount REAL NOT NULL,
        deposit REAL NOT NULL,
        isActive INTEGER NOT NULL,
        FOREIGN KEY (propertyId) REFERENCES properties (id) ON DELETE CASCADE,
        FOREIGN KEY (unitId) REFERENCES units (id) ON DELETE RESTRICT
      )
    ''');

    // Table 4: Payments
    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tenantId INTEGER NOT NULL,
        unitId INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        monthYear TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        notes TEXT,
        status TEXT NOT NULL,
        FOREIGN KEY (tenantId) REFERENCES tenants (id) ON DELETE CASCADE,
        FOREIGN KEY (unitId) REFERENCES units (id) ON DELETE CASCADE
      )
    ''');

    // Table 5: Expenses
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        propertyId INTEGER NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        description TEXT NOT NULL,
        FOREIGN KEY (propertyId) REFERENCES properties (id) ON DELETE CASCADE
      )
    ''');

    // Let's pre-populate with some initial dummy data so it isn't completely empty on first load!
    await _insertInitialSeedData(db);
  }

  Future<void> _insertInitialSeedData(Database db) async {
    // 1. Add 2 properties
    int prop1Id = await db.insert('properties', {
      'name': 'Skyline Apartments',
      'address': '12 Main Road, Dhanmondi, Dhaka',
      'floors': 8,
      'totalSize': 12000.0,
      'yearBuilt': 2020,
    });

    int prop2Id = await db.insert('properties', {
      'name': 'Rose Villa',
      'address': 'Block D, Banani, Dhaka',
      'floors': 5,
      'totalSize': 6500.0,
      'yearBuilt': 2018,
    });

    // 2. Add units for Skyline
    List<String> unitNames = ['A1', 'A2', 'B1', 'B2', 'C1'];
    List<int> uIds1 = [];
    for (var i = 0; i < unitNames.length; i++) {
      int id = await db.insert('units', {
        'propertyId': prop1Id,
        'unitNumber': unitNames[i],
        'rentAmount': 18000.0 + (i * 1000),
        'status': i < 3 ? 'occupied' : 'vacant',
      });
      uIds1.add(id);
    }

    // 3. Add tenants
    int tenant1Id = await db.insert('tenants', {
      'name': 'Khaled Osama',
      'email': 'khaled@example.com',
      'phone': '01712345678',
      'nid': '1995267890123',
      'propertyId': prop1Id,
      'unitId': uIds1[0],
      'leaseStart': '2026-01-01T00:00:00Z',
      'leaseEnd': '2027-01-01T00:00:00Z',
      'rentAmount': 18000.0,
      'deposit': 36000.0,
      'isActive': 1,
    });

    int tenant2Id = await db.insert('tenants', {
      'name': 'Rahim Ahmed',
      'email': 'rahim@gmail.com',
      'phone': '01898765432',
      'nid': '1988267895432',
      'propertyId': prop1Id,
      'unitId': uIds1[1],
      'leaseStart': '2025-06-01T00:00:00Z',
      'leaseEnd': '2026-06-01T00:00:00Z',
      'rentAmount': 19000.0,
      'deposit': 38000.0,
      'isActive': 1,
    });

    // 4. Insert some payments
    await db.insert('payments', {
      'tenantId': tenant1Id,
      'unitId': uIds1[0],
      'amount': 18000.0,
      'date': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'monthYear': 'May 2026',
      'paymentMethod': 'mobileBanking',
      'notes': 'Bkash personal',
      'status': 'paid',
    });

    await db.insert('payments', {
      'tenantId': tenant2Id,
      'unitId': uIds1[1],
      'amount': 19000.0,
      'date': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
      'monthYear': 'May 2026',
      'paymentMethod': 'bank',
      'notes': 'DBBL transfer',
      'status': 'paid',
    });

    // 5. Add some Expenses
    await db.insert('expenses', {
      'propertyId': prop1Id,
      'category': 'Utility',
      'amount': 4500.0,
      'date': DateTime.now().subtract(const Duration(days: 12)).toIso8601String(),
      'description': 'Electric main line repair',
    });
  }

  // --- CRUD Dynamic Methods ---

  // Universal Insert
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(table, row);
  }

  // Universal Fetch All
  Future<List<Map<String, dynamic>>> queryAll(String table, {String? orderBy}) async {
    final db = await instance.database;
    return await db.query(table, orderBy: orderBy);
  }

  // Universal Query Filter
  Future<List<Map<String, dynamic>>> queryWhere(
      String table, String where, List<dynamic> whereArgs, {String? orderBy}) async {
    final db = await instance.database;
    return await db.query(table, where: where, whereArgs: whereArgs, orderBy: orderBy);
  }

  // Universal Update
  Future<int> update(String table, Map<String, dynamic> row, String idColumn) async {
    final db = await instance.database;
    final id = row[idColumn];
    return await db.update(
      table,
      row,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  // Universal Delete
  Future<int> delete(String table, String idColumn, dynamic id) async {
    final db = await instance.database;
    return await db.delete(
      table,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  // Special Joined Query for Tenants with Unit & Property info
  Future<List<Map<String, dynamic>>> getTenantsWithDetails() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT t.*, p.name as propertyName, u.unitNumber as unitName
      FROM tenants t
      LEFT JOIN properties p ON t.propertyId = p.id
      LEFT JOIN units u ON t.unitId = u.id
      ORDER BY t.name ASC
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
