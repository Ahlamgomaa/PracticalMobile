import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/core/utils/mongo_helper.dart';
import 'package:notes_app/features/notes/data/models/data_model.dart';
import 'package:notes_app/features/notes/presentation/view_model/add_notes/add_notes_state.dart';

class AddNotesCubit extends Cubit<AddNotesState> {
  AddNotesCubit() : super(AddNotesInitial());

Future<void> addNote(NoteModel note) async {
  emit(AddNotesLoading());
  try {
    await MongoHelper.init();
    final noteId = await MongoHelper.addNote(note);
    emit(AddNotesSuccess(noteId: noteId));
  } catch (e) {
    emit(AddNotesFailure('Failed to add note: ${e.toString()}'));
  }
}

  void saveNoteToMongoDB({
    required String title,
    required String subtitle,
    required Color color,
  }) async {
    emit(AddNotesLoading());
    try {
      final note = NoteModel(
        title: title,
        subtitle: subtitle,
        // ignore: deprecated_member_use
        color: color.value,
        date: DateFormat.yMd().format(DateTime.now()),

      );
      await addNote(note);
    } catch (e) {
      emit(AddNotesFailure('Failed to save note: ${e.toString()}'));
    }
  }
}