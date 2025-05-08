import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/notes/data/models/data_model.dart';
import 'package:notes_app/features/notes/presentation/view_model/notes/notes_cubit.dart';
import 'package:notes_app/features/notes/presentation/views/edit_note_view.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({super.key, required this.note});

  final NoteModel note;

  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Note?'),
            content: const Text('Are you sure you want to delete this note?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<NotesCubit>().deleteNote(
                    note.id.toString(),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditNoteView(note: note)),
          ),
      child: Container(
        padding: const EdgeInsets.only(top: 24, bottom: 24, left: 16),
        decoration: BoxDecoration(
          color: Color(note.color),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              title: Text(
                note.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                child: Text(
                  note.subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(.6),
                    fontSize: 18,
                  ),
                ),
              ),
              trailing: IconButton(
                onPressed: () => _handleDelete(context),
                icon: const Icon(Icons.delete, color: Colors.black, size: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                note.date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(.4),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
