// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/core/utils/mongo_helper.dart';
import 'package:notes_app/features/notes/data/models/note_model.dart';
import 'package:notes_app/features/notes/presentation/view_model/add_notes/add_notes_state.dart';
import 'package:notes_app/features/notes/presentation/view_model/notes/notes_cubit.dart';

class AddNotesCubit extends Cubit<AddNotesState> {
  final NotesCubit notesCubit;

  AddNotesCubit(this.notesCubit) : super(AddNotesInitial());

  Future<void> addNote(NoteModel note) async {
    emit(AddNotesLoading());
    try {
      await MongoHelper.init();

      await notesCubit.addNewNote(note);
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
        color: color.value,
        date: DateFormat.yMd().format(DateTime.now()),
      );
      await addNote(note);
    } catch (e) {
      emit(AddNotesFailure('Failed to save note: ${e.toString()}'));
    }
  }
}
