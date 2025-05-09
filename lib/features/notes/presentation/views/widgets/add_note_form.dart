import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/notes/presentation/view_model/add_notes/add_notes_cubit.dart';
import 'package:notes_app/features/notes/presentation/view_model/add_notes/add_notes_state.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_button.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_text_field.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/edit_note_color_list.dart';

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key});

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? title, subtitle;
  Color selectedColor = const Color(0xFFA8D5E2);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          const SizedBox(height: 40),
          CustomTextField(
            onSaved: (value) => title = value,
            label: 'Title', maxLines: 1,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            onSaved: (value) => subtitle = value,
            label: 'Content', maxLines: 5,
        
          ),
          const SizedBox(height: 30),
          ColorListView(
            onColorSelected: (color) {
              setState(() => selectedColor = color);
            },
            initialColor: selectedColor,
          ),
          const SizedBox(height: 30),
          BlocBuilder<AddNotesCubit, AddNotesState>(
            builder: (context, state) {
              return CustomButton(
                isLoading: state is AddNotesLoading,
                onTap: _saveNoteToMongoDB,
              );
            },
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Future<void> _saveNoteToMongoDB() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      
    context.read<AddNotesCubit>().saveNoteToMongoDB(
  title: title!,
  subtitle: subtitle!,
  color: selectedColor,
);

    } else {
      setState(() => autovalidateMode = AutovalidateMode.always);
    }
  }
}