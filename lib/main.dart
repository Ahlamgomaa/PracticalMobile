import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/utils/mongo_helper.dart';
import 'package:notes_app/features/notes/presentation/view_model/add_notes/add_notes_cubit.dart';
import 'package:notes_app/features/notes/presentation/view_model/notes/notes_cubit.dart';
import 'package:notes_app/features/notes/presentation/views/notes_app.dart';
import 'package:notes_app/simple_bloc_observer.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();

  try {
    await MongoHelper.init();
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NotesCubit()..fetchAllNotes(),
            lazy: false,
          ),
          BlocProvider(create: (context) => AddNotesCubit()),
          
        ],

        child: const NotesApp(),
        
      ),
    );
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red[50],
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Connection Error',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Failed to connect to database: ${e.toString()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => main(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
