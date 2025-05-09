import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/utils/mongo_helper.dart';
import 'package:notes_app/features/notes/data/models/note_model.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  List<NoteModel> notes = [];

  Future<void> fetchAllNotes() async {
    emit(NotesLoading());
    try {
      final notesData = await MongoHelper.getAllNotes();
      notes = notesData.map((note) => NoteModel.fromJson(note)).toList();
      emit(NotesSuccess(notes));
    } catch (e) {
      emit(NotesFailure(e.toString()));
    }
  }
  Future<void> addNewNote(NoteModel note) async {
    emit(NotesLoading());
    try {
     
      final noteId = await MongoHelper.addNote(note);
      note.id = noteId;

      notes.insert(0, note);  

      emit(NotesSuccess(notes));  
    } catch (e) {
      emit(NotesFailure('Failed to add note: ${e.toString()}'));
    }
  }

  Future<void> updateNote(dynamic id, NoteModel updatedNote) async {
    emit(NotesLoading());
    try {
      final success = await MongoHelper.updateNote(id, updatedNote);

      if (success) {
        // ignore: unrelated_type_equality_checks
        final index = notes.indexWhere((n) => n.id == id);
        if (index != -1) {
          notes[index] = updatedNote;
        }
        await fetchAllNotes();

        emit(NotesUpdateSuccess(notes));
      } else {
        emit(NotesUpdateFailure('No changes were made'));
      }
    } catch (e) {
      emit(NotesUpdateFailure('Update failed: ${e.toString()}'));
    }
  }

  Future<void> deleteNote(dynamic id) async {
    emit(NotesLoading());
    try {
      final success = await MongoHelper.deleteNote(id);

      if (success) {
        notes.removeWhere((note) => note.id == id);
        await fetchAllNotes();
        
      } else {
        emit(NotesDeleteFailure('Note not found'));
         await fetchAllNotes(); 
      }
    } catch (e) {
      emit(NotesDeleteFailure('Delete error: ${e.toString()}'));
       await fetchAllNotes(); 
    }
  }
}
