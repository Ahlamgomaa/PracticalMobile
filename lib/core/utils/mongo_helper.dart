// ignore_for_file: avoid_print

import 'package:mongo_dart/mongo_dart.dart';
import 'package:notes_app/features/notes/data/models/note_model.dart';

class MongoHelper {
  static late Db db;
  static late DbCollection notesCollection;

  static Future<void> init() async {
    try {
      db = await Db.create(
        'mongodb+srv://shehabwww153:cmCqBjtQCQDWbvlo@userauth.rvtb5.mongodb.net/NOTES?retryWrites=true&w=majority&appName=userAuth',
      );
      await db.open();
      if (!db.isConnected) {
        throw Exception('Failed to establish database connection');
      }

      notesCollection = db.collection('notes');

      print('✅ MongoDB connected successfully');
    } catch (e) {
      print('❌ MongoDB connection error: $e');
      rethrow;
    }
  }

  static Future<String> addNote(NoteModel note) async {
    try {
      final result = await notesCollection.insertOne({
        'title': note.title,
        'subtitle': note.subtitle,
        'color': note.color,
        'date': note.date,
      });

      final allNotes = await notesCollection.find().toList();
      print("📋 All Notes: $allNotes");
      print("✅ Inserted ID: ${result.id}");
      return result.id.toString();
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  static Future<bool> updateNote(dynamic id, NoteModel note) async {
    try {
      final existing = await notesCollection.findOne(where.eq('_id', id));
      if (existing == null) {
        print('Note with ID $id not found.');
        return false;
      }

      await notesCollection.update(
        where.eq('_id', id),
        modify
            .set('title', note.title)
            .set('subtitle', note.subtitle)
            .set('color', note.color)
            .set('date', note.date)
            .set('updatedAt', DateTime.now()),
      );

      return true;
    } catch (e) {
      print('Error updating note: $e');
      return false;
    }
  }

  static Future<bool> deleteNote(dynamic id) async {
    try {
      if (!notesCollection.db.isConnected) {
        await notesCollection.db.open();
      }

      dynamic query;
      try {
        query = where.eq('_id', id);
      } catch (e) {
        query = where.eq('_id', id);
      }

      final result = await notesCollection.deleteOne(query);

      if (result.isAcknowledged) {
        print('✅ Note with ID $id deleted successfully');
        return true;
      } else {
        print('❌ Note with ID $id not found or deletion failed');
        return false;
      }
    } catch (e) {
      print('Delete error for ID $id: $e');
      throw Exception('Delete operation failed: ${e.toString()}');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllNotes() async {
    try {
      return await notesCollection.find().toList();
    } catch (e) {
      throw Exception('Failed to get notes: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> searchNotes(String query) async {
    try {
      return await notesCollection.find({
        '\$or': [
          {
            'title': {'\$regex': query, '\$options': 'i'},
          },
          {
            'subtitle': {'\$regex': query, '\$options': 'i'},
          },
        ],
      }).toList();
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  static Future<void> close() async {
    if (db.isConnected) {
      await db.close();
    }
  }
}
