import 'package:firebase_core/firebase_core.dart';
import '../core/services/token_service.dart';

class AppInitializer {
  static Future<void> init() async {
    // Initialize token and session storage
    await TokenService.init();
  }
}