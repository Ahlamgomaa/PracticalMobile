import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/notes/data/models/note_model.dart';
import 'package:notes_app/features/notes/presentation/view_model/notes/notes_cubit.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_app_bar.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_text_field.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/edit_note_color_list.dart';

class EditNoteViewBody extends StatefulWidget {
  const EditNoteViewBody({super.key, required this.note});
  final NoteModel note;

  @override
  State<EditNoteViewBody> createState() => _EditNoteViewBodyState();
}

class _EditNoteViewBodyState extends State<EditNoteViewBody> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _subtitleController = TextEditingController(text: widget.note.subtitle);
    selectedColor = Color(widget.note.color?? Colors.blue.value); 
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _updateNote() async {
    if (_titleController.text.isEmpty || _subtitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both title and content')),
      );
      return;
    }

    final updatedNote = NoteModel(
      id: widget.note.id,
      title: _titleController.text,
      subtitle: _subtitleController.text,
      // ignore: deprecated_member_use
      color: selectedColor.value, 
      date: DateTime.now().toString(),
    );

    debugPrint('Updating note with data: ${updatedNote.toJson()}');


    if (updatedNote.id != null) {
      context.read<NotesCubit>().updateNote(
       updatedNote.id,
        updatedNote,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesCubit, NotesState>(
      listener: (context, state) {
        if (state is NotesUpdateSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(' Note updated successfully')),
          );
           context.read<NotesCubit>().fetchAllNotes();
        }
        if (state is NotesUpdateFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 60),
            CustomAppBar(
              onPressed: _updateNote,
              title: ' Edit note',
              icon: Icons.check,
            ),
            const SizedBox(height: 60),
            CustomTextField(
              controller: _titleController,
              hint: 'title',
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _subtitleController,
              hint: 'content',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ColorListView(
              initialColor: selectedColor,
              onColorSelected: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
