import 'package:firebase_core/firebase_core.dart';
import 'package:messageapp/firebase_options.dart';
import '../core/services/token_service.dart';

class AppInitializer {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await TokenService.init();
  }
}
