import 'package:flutter/material.dart';
import 'package:note/note.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    List<Note> notes = await _dbHelper.getAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _deleteNote(Note note) async {
    await _dbHelper.deleteNote(note: note);
    _refreshNotes();
  }

  void _reorderNotes(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _notes.removeAt(oldIndex);
      _notes.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secure Notes'),
      ),
      body: ReorderableListView(
        onReorder: _reorderNotes,
        children: _notes.map((note) => ListTile(
          key: ValueKey(note.id),
          title: Text(note.title),
          subtitle: Text(note.body),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditNoteScreen(note: note)),
            );
            _refreshNotes();
          },
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteNote(note),
          ),
        )).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNoteScreen()),
          );
          _refreshNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
