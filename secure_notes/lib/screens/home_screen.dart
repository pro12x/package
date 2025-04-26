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

  void _confirmDeleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All Notes'),
        content: Text('Are you sure you want to delete all notes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _dbHelper.deleteAllNotes();
              Navigator.pop(context);
              _refreshNotes();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _confirmDeleteAll,
          ),
        ],
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
