import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/member_model.dart';
import '../Model/room_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'room_booking.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rooms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        roomId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE members(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        roomId INTEGER,
        firstName TEXT,
        lastName TEXT,
        dateOfBirth TEXT,
        isChild INTEGER,
        isPet INTEGER,
        FOREIGN KEY (roomId) REFERENCES rooms (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertRoom(Room room) async {
    final db = await database;
    return await db.insert('rooms', {'roomId': room.id});
  }

  Future<int> insertMember(Member member, int roomId) async {
    final db = await database;
    return await db.insert('members', {
      'roomId': roomId,
      'firstName': member.firstName,
      'lastName': member.lastName,
      'dateOfBirth': member.dateOfBirth,
      'isChild': member.isChild ? 1 : 0,
      'isPet': member.isPet ? 1 : 0,
    });
  }

  Future<List<Room>> getRooms() async {
    final db = await database;
    final List<Map<String, dynamic>> roomsData = await db.query('rooms');
    List<Room> roomsList = [];

    for (var roomData in roomsData) {
      final List<Map<String, dynamic>> membersData = await db.query(
        'members',
        where: 'roomId = ?',
        whereArgs: [roomData['id']],
      );

      List<Member> members = membersData.map((memberData) {
        return Member(
          firstName: memberData['firstName'],
          lastName: memberData['lastName'],
          dateOfBirth: memberData['dateOfBirth'],
          isChild: memberData['isChild'] == 1,
          isPet: memberData['isPet'] == 1,
        );
      }).toList();

      roomsList.add(Room(id: roomData['roomId'], members: members));
    }

    return roomsList;
  }
  Future<int> deleteMember(Member member, int roomId) async {
    final db = await database;
    return await db.delete(
      'members',
      where: 'id = ? AND roomId = ?',
      whereArgs: [member.id, roomId],
    );
  }
}
