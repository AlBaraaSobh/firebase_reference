import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elancer_firebase/firebase/fb_auth_controller.dart';
import 'package:elancer_firebase/firebase/fb_firestore_controller.dart';
import 'package:elancer_firebase/firebase/fb_notifications.dart';
import 'package:elancer_firebase/models/fb_response.dart';
import 'package:elancer_firebase/models/note.dart';
import 'package:elancer_firebase/screens/app/note_screen.dart';
import 'package:elancer_firebase/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with FbNotifications  {
  @override
  void initState() {
    _setupNotifications();
    super.initState();
  }

  void _setupNotifications() async {
    // طلب الأذونات لـ iOS
    await requestNotificationPermissions();

    // تفعيل الإشعارات المقدمة لـ Android
    initializeForegroundNotificationForAndroid();

    // التعامل مع النقر على الإشعارات
    manageNotificationAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
       // Navigator.pushNamed(context, '/note_screen');
        Navigator.pushNamed(context, '/notification_screen');
      },),
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              FbAuthController().singOut();
              Navigator.pushNamed(context, '/login_screen');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Note>>(
        stream: FbFirestoreController().read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(
                          note: getNote(snapshot.data!.docs[index]),
                        ),
                      ),
                    );
                  },
                  title: Text(snapshot.data!.docs[index].data().title),
                  subtitle: Text(snapshot.data!.docs[index].data().info),
                  leading: Icon(Icons.note),
                  trailing: IconButton(
                    onPressed: () {
                      _delete(context,snapshot.data!.docs[index].id);
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'NO Notes',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _delete(BuildContext context,String id)async{
      FbResponse  fbResponse = await FbFirestoreController().delete(id);
      context.showSnackBar(message: fbResponse.message ,error: !fbResponse.success);
  }

  Note getNote(
    QueryDocumentSnapshot<Note> queryDocumentSnapshot,
  ) {
    Note note = Note();
    note.id = queryDocumentSnapshot.id;
    note.title = queryDocumentSnapshot.data().title;
    note.info = queryDocumentSnapshot.data().info;
    return note;
  }
}
