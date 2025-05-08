

abstract class AddNotesState {}

class AddNotesInitial extends AddNotesState {}

class AddNotesLoading extends AddNotesState {}

class AddNotesSuccess extends AddNotesState {
  final String? noteId;
  AddNotesSuccess({this.noteId});
}

class AddNotesFailure extends AddNotesState {
  final String errorMassage;

  AddNotesFailure(this.errorMassage);
}