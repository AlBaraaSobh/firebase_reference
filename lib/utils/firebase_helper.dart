import 'package:elancer_firebase/models/fb_response.dart';

mixin FirebaseHelper {
  FbResponse get successResponse => FbResponse('Operation Completed successfully', true);
  FbResponse get failedResponse => FbResponse('Operation Failed', false);
}