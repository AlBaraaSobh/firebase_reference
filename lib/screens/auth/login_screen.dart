import 'package:elancer_firebase/models/fb_response.dart';
import 'package:elancer_firebase/firebase/fb_auth_controller.dart';
import 'package:elancer_firebase/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  void initState() {
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LOGIN')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Text(
              'Welcome Back..😎',
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
            SizedBox(height: 20),
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
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordTextController,
              obscureText: true,
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
              onPressed: () => _performLogin(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                minimumSize: Size(double.infinity,50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('LOGIN'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account'),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/register_screen');
                }, child: Text('Create Now!'))

              ],
            ),
          ],
        ),
      ),
    );
  }

  void _performLogin() async{
    if(_checkData()){
      await _login();
    }
  }


  bool _checkData(){
    if(_emailTextController.text.isEmpty){
      context.showSnackBar(message: 'الرجاء إدخال الإيميل', error: true);
      return false;
    }

    if(_passwordTextController.text.isEmpty){
      context.showSnackBar(message: 'الرجاء إدخال كلمة المرور', error: true);
      return false;
    }

    // يمكن إضافة تحقق من صحة تنسيق الإيميل هنا
    if(!_emailTextController.text.contains('@')){
      context.showSnackBar(message: 'تنسيق الإيميل غير صحيح', error: true);
      return false;
    }

    return true;
  }
  Future<void> _login() async {
    FbResponse fbResponse = await FbAuthController().singIn(
        _emailTextController.text,
        _passwordTextController.text
    );

    // عرض الرسالة أولاً
    context.showSnackBar(
        message: fbResponse.message,
        error: !fbResponse.success
    );

    // إذا كان تسجيل الدخول ناجحًا، انتقل للشاشة الرئيسية
    if(fbResponse.success){
      // انتظار قليل لضمان ظهور الرسالة قبل الانتقال
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pushReplacementNamed(context, '/home_screen');
     // Navigator.pushReplacementNamed(context, '/notification_screen');
    }
  }

}
