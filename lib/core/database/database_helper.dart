import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Helper para gestionar la base de datos SQLite de UniMarket
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  /// Inicializar la base de datos
  Future<Database> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'unimarket.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  /// Crear todas las tablas
  Future<void> _createTables(Database db, int version) async {
    // Tabla: Roles
    await db.execute('''
      CREATE TABLE IF NOT EXISTS roles (
        id TEXT PRIMARY KEY,
        name TEXT UNIQUE NOT NULL,
        permissions TEXT
      )
    ''');

    // Tabla: Users
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        phone TEXT UNIQUE NOT NULL,
        role_id TEXT NOT NULL,
        profile_pic_url TEXT,
        email_verified INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        last_login TEXT,
        FOREIGN KEY(role_id) REFERENCES roles(id)
      )
    ''');

    // Tabla: Entrepreneurs
    await db.execute('''
      CREATE TABLE IF NOT EXISTS entrepreneurs (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL UNIQUE,
        business_name TEXT NOT NULL,
        owner_name TEXT NOT NULL,
        category TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        description TEXT,
        verification_level INTEGER DEFAULT 0,
        status TEXT DEFAULT 'pending',
        rejection_reason TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    // Tabla: Entrepreneur Documents
    await db.execute('''
      CREATE TABLE IF NOT EXISTS entrepreneur_documents (
        id TEXT PRIMARY KEY,
        entrepreneur_id TEXT NOT NULL,
        doc_type TEXT NOT NULL,
        file_url TEXT NOT NULL,
        status TEXT DEFAULT 'pending',
        rejection_reason TEXT,
        verified_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(entrepreneur_id) REFERENCES entrepreneurs(id)
      )
    ''');

    // Tabla: Bank Accounts
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bank_accounts (
        id TEXT PRIMARY KEY,
        entrepreneur_id TEXT NOT NULL,
        bank_name TEXT NOT NULL,
        account_number TEXT NOT NULL,
        account_holder TEXT NOT NULL,
        account_type TEXT,
        bank_code TEXT,
        verified INTEGER DEFAULT 0,
        available_balance REAL DEFAULT 0,
        total_earnings REAL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(entrepreneur_id) REFERENCES entrepreneurs(id)
      )
    ''');

    // Tabla: Categories
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id TEXT PRIMARY KEY,
        name TEXT UNIQUE NOT NULL,
        icon_url TEXT,
        description TEXT,
        order_by INTEGER,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabla: Products
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id TEXT PRIMARY KEY,
        entrepreneur_id TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        category_id TEXT NOT NULL,
        price REAL NOT NULL,
        discount_price REAL,
        stock INTEGER NOT NULL DEFAULT 0,
        images_url TEXT,
        rating REAL DEFAULT 0,
        review_count INTEGER DEFAULT 0,
        is_featured INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(entrepreneur_id) REFERENCES entrepreneurs(id),
        FOREIGN KEY(category_id) REFERENCES categories(id)
      )
    ''');

    // Tabla: Reviews
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reviews (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        rating INTEGER NOT NULL,
        comment TEXT,
        verified_purchase INTEGER DEFAULT 0,
        helpful_count INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(product_id) REFERENCES products(id),
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    // Tabla: Favorites
    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(user_id, product_id),
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');

    // Tabla: Cart Items
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cart_items (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        added_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        UNIQUE(user_id, product_id),
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');

    // Tabla: Orders
    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        total_amount REAL NOT NULL,
        status TEXT DEFAULT 'pending',
        payment_status TEXT DEFAULT 'pending',
        shipping_address TEXT NOT NULL,
        tracking_number TEXT,
        delivery_date TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    // Tabla: Order Items
    await db.execute('''
      CREATE TABLE IF NOT EXISTS order_items (
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        subtotal REAL NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY(order_id) REFERENCES orders(id),
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');

    // Tabla: Payments
    await db.execute('''
      CREATE TABLE IF NOT EXISTS payments (
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        method TEXT NOT NULL,
        amount REAL NOT NULL,
        transaction_id TEXT UNIQUE,
        status TEXT DEFAULT 'pending',
        error_message TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(order_id) REFERENCES orders(id)
      )
    ''');

    // Tabla: Addresses
    await db.execute('''
      CREATE TABLE IF NOT EXISTS addresses (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        alias TEXT,
        street TEXT NOT NULL,
        number TEXT,
        city TEXT NOT NULL,
        state TEXT NOT NULL,
        postal_code TEXT NOT NULL,
        country TEXT DEFAULT 'Colombia',
        latitude REAL,
        longitude REAL,
        is_default INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    // Tabla: Admin Reports
    await db.execute('''
      CREATE TABLE IF NOT EXISTS admin_reports (
        id TEXT PRIMARY KEY,
        report_type TEXT NOT NULL,
        period_start TEXT,
        period_end TEXT,
        total_users INTEGER,
        active_entrepreneurs INTEGER,
        total_products INTEGER,
        total_orders INTEGER,
        total_sales REAL,
        total_revenue REAL,
        top_products TEXT,
        top_entrepreneurs TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Crear índices
    await _createIndexes(db);
  }

  /// Crear índices para mejorar performance
  Future<void> _createIndexes(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_products_entrepreneur_id ON products(entrepreneur_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_reviews_product_id ON reviews(product_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON reviews(user_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_cart_items_user_id ON cart_items(user_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_addresses_user_id ON addresses(user_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_entrepreneur_docs_entrepreneur_id ON entrepreneur_documents(entrepreneur_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_bank_accounts_entrepreneur_id ON bank_accounts(entrepreneur_id)',
    );
  }

  /// Manejar actualizaciones de esquema
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migración cuando sea necesario
    // Ejemplo:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE users ADD COLUMN new_column TEXT');
    // }
  }

  /// Cerrar la base de datos
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Método genérico para insertar
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  /// Método genérico para actualizar
  Future<int> update(
    String table,
    Map<String, dynamic> values,
    String where,
  ) async {
    final db = await database;
    return await db.update(table, values, where: where);
  }

  /// Método genérico para eliminar
  Future<int> delete(String table, String where) async {
    final db = await database;
    return await db.delete(table, where: where);
  }

  /// Método genérico para consultar
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  /// Método genérico para consulta única
  Future<Map<String, dynamic>?> queryFirstRow(
    String table,
    String where, [
    List<dynamic>? whereArgs,
  ]) async {
    final db = await database;
    final result = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Ejecutar transacción
  Future<T> transaction<T>(Future<T> Function(Transaction) action) async {
    final db = await database;
    return await db.transaction(action);
  }

  /// Limpiar base de datos (para testing)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'unimarket.db');
    await deleteDatabaseFile(path);
    _database = null;
  }

  /// Eliminar archivo de base de datos
  Future<void> deleteDatabaseFile(String path) async {
    try {
      // Implementar eliminar archivo según plataforma
    } catch (e) {
      print('Error deleting database: $e');
    }
  }
}
