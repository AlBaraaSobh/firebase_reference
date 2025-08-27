import 'package:elancer_firebase/models/fb_response.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FbAuthController {
  //SingInWithEmail&Password
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FbResponse> singIn(String email, String password) async {

    try{

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
      if(userCredential.user!.emailVerified){
        return FbResponse('Logged in Successfully', true);
      }else{
        await userCredential.user!.sendEmailVerification();
        return FbResponse('verify your email', false);

      }

    }on FirebaseAuthException catch(e) {
      return FbResponse(e.message ?? '', false);
    } catch (e){
      return FbResponse('Something went wrong ', false);
    }

  }

  Future<FbResponse> createAccount(String name ,String email, String password ) async {
    try{
      UserCredential userCredential =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.sendEmailVerification();
      return FbResponse('Register Successfully , verify email', true);

    } on FirebaseAuthException catch (e){
      return FbResponse(e.message ?? '', false);

    }catch(e){
      return FbResponse('Something went wrong ', false);

    }

  }

  Future<void> singOut()async{
   await _auth.signOut();
  }

  User get currentUser => _auth.currentUser!;

  Future<FbResponse> forgetPassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return FbResponse('Reset Email Successfully , verify email', true);

    } on FirebaseAuthException catch (e){
      return FbResponse(e.message ?? '', false);

    }catch(e){
      return FbResponse('Something went wrong ', false);

    }

  }

  }
