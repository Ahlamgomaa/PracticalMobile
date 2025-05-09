import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/utils/mongo_helper.dart';
import 'package:notes_app/features/notes/presentation/view_model/add_notes/add_notes_cubit.dart';
import 'package:notes_app/features/notes/presentation/view_model/notes/notes_cubit.dart';
import 'package:notes_app/features/notes/presentation/views/error_view.dart';
import 'package:notes_app/features/notes/presentation/views/notes_app.dart';
import 'package:notes_app/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  try {
    await startApp();
  } catch (e) {
    runApp(ErrorView(error: e.toString()));
  }
}

Future<void> startApp() async {
  await MongoHelper.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotesCubit()..fetchAllNotes(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => AddNotesCubit(context.read<NotesCubit>()),
        ),
      ],
      child: const NotesApp(),
    ),
  );
}
