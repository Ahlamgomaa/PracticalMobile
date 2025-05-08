part of 'notes_cubit.dart';

@immutable
abstract class NotesState {}
// get notes from the database

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesSuccess extends NotesState {
  final List<NoteModel> notes;
  NotesSuccess(this.notes);
}

class NotesFailure extends NotesState {
  final String error;
  NotesFailure(this.error);
}
// update notes in the database
class NotesUpdateSuccess extends NotesState {

}

class NotesUpdateFailure extends NotesState {
  final String error;
  NotesUpdateFailure(this.error);
}
// delete notes in the database
class NotesDeleteFailure extends NotesState {
  final String error;
  NotesDeleteFailure(this.error);
}
