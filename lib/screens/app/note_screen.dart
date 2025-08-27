import 'package:elancer_firebase/firebase/fb_auth_controller.dart';
import 'package:elancer_firebase/firebase/fb_firestore_controller.dart';
import 'package:elancer_firebase/models/note.dart';
import 'package:elancer_firebase/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/fb_response.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key, this.note});

  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  // @override
  // void initState() {
  //   _titleTextController = TextEditingController();
  //   _infoTextController = TextEditingController();
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(
      text: widget.note?.title ?? '',
    );
    _infoTextController = TextEditingController(
      text: widget.note?.info ?? '',
    );
  }


  @override
  void dispose() {
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text(isNewNote ? 'Create Note' : 'Update Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: GoogleFonts.poppins(),
              controller: _titleTextController,
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _infoTextController,
              style: GoogleFonts.poppins(),
              textCapitalization: TextCapitalization.words,
              autocorrect: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Info',
                counterText: '',
                prefixIcon: Icon(Icons.info),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _performSave(),
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isNewNote => widget.note == null;

  void _performSave() {
    if (_checkData()) {
      _save();
    }
  }

  bool _checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty) {
      return true;
    }
    context.showSnackBar(message: 'Enter Required Data', error: true);
    return false;
  }

  // void _save() async {
  //   isNewNote ? await FbFirestore().create(note): await FbFirestore().update(note);
  // }

  void _save() async {
    FbResponse response = isNewNote
        ? await FbFirestoreController().create(note)
        : await FbFirestoreController().update(note);

    if (mounted) {
      context.showSnackBar(
        message: response.message,
        error: !response.success,
      );
    }

    if (response.success && mounted) {
      Navigator.pop(context); // ✅ ارجع للشاشة الرئيسية بعد الحفظ
    }
  }

  Note get note{
    Note note = isNewNote ? Note() : widget.note!;
    note.title = _titleTextController.text;
    note.info = _infoTextController.text;
    return note;
  }
}
