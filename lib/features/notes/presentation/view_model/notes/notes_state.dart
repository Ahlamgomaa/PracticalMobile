part of 'notes_cubit.dart';

@immutable
abstract class NotesState {}


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

class NotesUpdateSuccess extends NotesState {
  final List<NoteModel> notes;
  NotesUpdateSuccess(this.notes);

}

class NotesUpdateFailure extends NotesState {
  final String error;
  NotesUpdateFailure(this.error);
}
class NotesDeletedSucess extends NotesState {
  final List<NoteModel> notes;
  NotesDeletedSucess(this.notes);
}

class NotesDeleteFailure extends NotesState {
  final String error;
  NotesDeleteFailure(this.error);
}
