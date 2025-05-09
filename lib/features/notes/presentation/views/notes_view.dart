import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/notes/presentation/view_model/notes/notes_cubit.dart';
import 'package:notes_app/features/notes/presentation/views/custom_widgets/custom_add_note_sheet.dart';
import 'package:notes_app/features/notes/presentation/views/custom_widgets/custom_app_bar.dart';
import 'package:notes_app/features/notes/presentation/views/custom_widgets/custom_note_item.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Notes', icon: Icons.search),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColorLight,
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
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotesFailure) {
              return Center(child: Text(state.error));
            }

            // إذا كانت الحالة هي NotesSuccess أو حالة تحديث أو حذف، سيتم عرض الملاحظات
            if (state is NotesSuccess || state is NotesUpdateSuccess || state is NotesDeletedSucess) {
              final notes = (state as NotesSuccess).notes; // تأكد من الوصول للملاحظات بشكل صحيح
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
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
