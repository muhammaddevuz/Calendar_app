// ignore_for_file: avoid_print
// ignore: depend_on_referenced_packages
import 'package:calendar_app/data/datasources/event_local_database.dart';
import 'package:calendar_app/data/models/event_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EventLocalDataSourcePerf implements EventLocalDataSource {
  static final EventLocalDataSourcePerf _instance = EventLocalDataSourcePerf._init();
  static Database? _eventDatabase;

  EventLocalDataSourcePerf._init();

  // Singleton bo'lgan instansiyani qaytaruvchi factory konstruktor
  factory EventLocalDataSourcePerf() {
    return _instance;
  }

  // Bazaga ulanish yoki mavjud bo'lsa uni qaytarish uchun getter
  Future<Database> get eventDatabase async {
    if (_eventDatabase != null) return _eventDatabase!;
    try {
      _eventDatabase = await _initDB('eventsBase.db'); // Bazani yaratish yoki ochish
      return _eventDatabase!;
    } catch (e) {
      print('Bazani ochishda xato: $e');
      rethrow;  
    }
  }

  // Bazani yo'lini topish va uni yaratish
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // Bazaning yo'lini olish
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, // Agar baza mavjud bo'lmasa, uni yaratish
    );
  }

  // Baza jadvalini yaratish funksiyasi
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE eventsBase (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_name TEXT,
        event_description TEXT,
        event_location TEXT,
        event_color INTEGER,
        event_date_time TEXT,
        event_end_time TEXT,
        event_date_time_info TEXT
      )
    ''');
  }

  // Event qo'shish funksiyasi
  @override
  Future<void> insertEvent(EventModel event) async {
    final db = await eventDatabase;
    try {
      await db.insert('eventsBase', event.toMap()); // Eventni jadvalga kiritish
    } catch (e) {
      print('Event qo\'shishda xato: $e');
      print('Event ma\'lumotlari: ${event.toMap()}');
      rethrow;
    }
  }

  // Barcha eventlarni olish funksiyasi
  @override
  Future<List<EventModel>> getEvents() async {
    final db = await eventDatabase;
    try {
      final result = await db.query('eventsBase'); // Eventlarni jadvaldan o'qish
      return result.map((json) => EventModel.fromMap(json)).toList(); // Olingan eventlarni modelga aylantirish
    } catch (e) {
      print('Eventlarni olishda xato: $e');
      rethrow;
    }
  }

  // Eventni o'chirish funksiyasi
  @override
  Future<void> deleteEvent(int id) async {
    final db = await eventDatabase;
    try {
      await db.delete(
        'eventsBase',
        where: 'id = ?',
        whereArgs: [id], // Eventni ID orqali o'chirish
      );
    } catch (e) {
      print('Eventni o\'chirishda xato: $e');
      rethrow;
    }
  }

  // Eventni tahrirlash funksiyasi
  @override
  Future<void> editEvent(EventModel event) async {
    final db = await eventDatabase;
    try {
      await db.update(
        'eventsBase',
        event.toMap(),
        where: 'id = ?',
        whereArgs: [event.id], // Eventni ID orqali tahrirlash
      );
    } catch (e) {
      print('Eventni tahrirlashda xato: $e');
      rethrow;
    }
  }

  // Jadval tuzilmasini tekshirish funksiyasi
  Future<void> checkTableStructure() async {
    final db = await eventDatabase;
    var tableInfo = await db.rawQuery("PRAGMA table_info('eventsBase')"); // Jadval tuzilmasini olish
    print('Jadval tuzilmasi: $tableInfo');
  }
}
