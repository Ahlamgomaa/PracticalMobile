import 'package:flutter/material.dart';
import 'package:notes_app/core/utils/mongo_helper.dart';
import 'package:notes_app/features/notes/data/models/note_model.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_note_item.dart';
import 'package:notes_app/features/notes/presentation/views/widgets/custom_text_field.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<NoteModel> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Search',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 3,
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
          child: Column(
            children: [
              CustomTextField(
                controller: _searchController,
                hint: 'Search notes',
                label: 'Search',
                searchIcon: true,
                debounceDuration: const Duration(milliseconds: 500),
                onChanged: _performSearch,
                maxLines: 4,
              ),

              Expanded(child: _buildSearchResults()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    try {
      final results = await MongoHelper.searchNotes(query);
      setState(() {
        _searchResults = results.map((e) => NoteModel.fromJson(e)).toList();
      });
    } catch (e) {
    
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Search error: ${e.toString()}')));
    }
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return const Center(child: Text('Start typing to search notes'));
    }

    if (_searchResults.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.separated(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final note = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: NoteItem(note: note),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
