import 'package:elancer_firebase/models/fb_response.dart';
import 'package:elancer_firebase/firebase/fb_auth_controller.dart';
import 'package:elancer_firebase/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  void initState() {
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Text(
              'Welcome..🤞',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1,
              ),
            ),
            Text(
              'Enter Email & Password ',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 15,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 14),
            TextField(
              keyboardType: TextInputType.name,
              controller: _nameTextController,
              decoration: InputDecoration(
                hintText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 14),

            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailTextController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _passwordTextController,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1, color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _performRegister(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                minimumSize: Size(double.infinity,50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Register'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('I\'have an account'),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/login_screen');
                }, child: Text('Login Now!'))

              ],
            ),
          ],
        ),
      ),
    );
  }

  void _performRegister() async{
    if(_checkData()){
      await _register();
    }
  }
  bool _checkData(){
    if(_passwordTextController.text.isNotEmpty &&
        _emailTextController.text.isNotEmpty &&
        _nameTextController.text.isNotEmpty ){
      return true;
    }
    return false;
  }

  Future<void> _register() async {
    FbResponse fbResponse = await FbAuthController().createAccount(
        _nameTextController.text,_emailTextController.text, _passwordTextController.text);
    if(fbResponse.success){
      Navigator.pop(context);
      context.showSnackBar(message: fbResponse.message,error: !fbResponse.success);
    }
  }
}
