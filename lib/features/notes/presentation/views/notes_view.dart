import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/notes/presentation/view_model/notes/notes_cubit.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_add_note_sheet.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_app_bar.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_note_item.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Notes', icon: Icons.search),
       floatingActionButton: FloatingActionButton(
  backgroundColor: Theme.of(context).primaryColor,
  foregroundColor: Colors.white,
  onPressed: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddNoteSheet(),
    );
  },
  child: const Icon(Icons.add),
),
        body: BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) {
            final cubit = context.read<NotesCubit>();
            
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is NotesFailure) {
              return Center(child: Text(state.error));
            }
            
            if (state is NotesSuccess || state is NotesInitial) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: cubit.notes.length,
                  itemBuilder: (context, index) {
                    final note = cubit.notes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: NoteItem(note: note),
                    );
                  },
                ),
              );
            }
            
            return Container();
          },
        ),
      ),
    );
  }
}