import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/Features/Me/presentation/screens/change_password/change_password_screen.dart';
import 'package:messageapp/Features/Me/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:messageapp/Features/Me/presentation/screens/notifications/notification_list_screen.dart';
import 'package:messageapp/Features/Me/presentation/screens/notifications/notification_settings_screen.dart';
import 'package:messageapp/Features/Me/presentation/screens/security_privacy/security_privacy_screen.dart';
import 'package:messageapp/Features/ProductDetails/data/models/product_model.dart';
import 'package:messageapp/Features/ProductDetails/product_detals.dart';
import 'package:messageapp/Features/auth/presentation/screens/Auth/email_verification_screen.dart';
import 'package:messageapp/Features/auth/presentation/screens/Auth/login_screen.dart';
import 'package:messageapp/Features/auth/presentation/screens/Auth/register_screen.dart';
import '../../Features/Me/presentation/screens/Help_Support/help_support.dart';
import '../../Features/Search/screen/search_screen.dart';
import '../../Features/auth/presentation/screens/splash/splash_screen.dart';
import '../../Features/bottom_nav_bar/presentation/screens/bottom_manu_wrappers.dart';
import '../constants/app_constants.dart';


CustomTransitionPage<dynamic> buildSlideTransitionPage({
  required LocalKey key,
  required Widget child,
  Offset begin = const Offset(1.0, 0.0),
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
        ) {
      final tween = Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}


final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppPaths.splash,
    routes: [

      GoRoute(
        path: AppPaths.splash,
        name: AppRoutes.splash,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: SplashScreen(),
        ),
      ),

      GoRoute(
        path: AppPaths.bottom_manu,
        name: AppRoutes.bottom_manu,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: BottomMenuWrapper(),
        ),
      ),

      GoRoute(
        path: AppPaths.product_details,
        name: AppRoutes.product_details,
        pageBuilder: (context, state) {
          final product = state.extra is ScannedProduct
              ? state.extra as ScannedProduct
              : const ScannedProduct(
                  id: 'placeholder',
                  url: '',
                  title: 'Mini Multi-Functional Pot',
                  description: 'Non-stick coating, for food contact. Multi-function cooking, delicacy. Two levels of firepower, firepower can be big or small...',
                  price: 110.90,
                  originalPrice: 110.0,
                  currency: 'USD',
                  imageUrls: ['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqqdAMrQcJJr0-KSmcWeuYoJRYi6KSAczCOocvlPPg4A&s=10'],
                  scanCount: 2181,
                  scans: [],
                );
          return buildSlideTransitionPage(
            key: state.pageKey,
            child: ProductDetailsScreen(product: product),
          );
        },
      ),

      GoRoute(
        path: AppPaths.search_product,
        name: AppRoutes.search_product,
        pageBuilder: (context, state) {
          String? url;
          String? imagePath;
          if (state.extra is String) {
            url = state.extra as String;
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            url = map['url'] as String?;
            imagePath = map['imagePath'] as String?;
          }
          return buildSlideTransitionPage(
            key: state.pageKey,
            child: AnalysisDataScreen(url: url, imagePath: imagePath),
          );
        },
      ),

      GoRoute(
        path: AppPaths.help_support,
        name: AppRoutes.help_support,
        pageBuilder: (context, state) {
          final url = state.extra as String?;
          return buildSlideTransitionPage(
            key: state.pageKey,
            child: HelpSupport(),
          );
        },
      ),

      GoRoute(
        path: AppPaths.login,
        name: AppRoutes.login,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: LoginScreen(),
        ),
      ),


      GoRoute(
        path: AppPaths.register,
        name: AppRoutes.register,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: RegisterScreen(),
        ),
      ),

      GoRoute(
        path: AppPaths.emailVerification,
        name: AppRoutes.emailVerification,
        pageBuilder: (context, state) {
          final email = state.extra is String ? state.extra as String : '';
          return buildSlideTransitionPage(
            key: state.pageKey,
            child: EmailVerificationScreen(email: email),
          );
        },
      ),

      GoRoute(
        path: AppPaths.notification_setting,
        name: AppRoutes.notification_setting,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: const NotificationSettingsScreen(),
        ),
      ),

      GoRoute(
        path: AppPaths.notification_screen,
        name: AppRoutes.notification_screen,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: const NotificationListScreen(),
        ),
      ),
      //
      // GoRoute(
      //   path: AppPaths.email_setting,
      //   name: AppRoutes.email_setting,
      //   pageBuilder: (context, state) => buildSlideTransitionPage(
      //     key: state.pageKey,
      //     child: EmailSettingsScreen(),
      //   ),
      // ),

      GoRoute(
        path: AppPaths.security_privacy,
        name: AppRoutes.security_privacy,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: SecurityPrivacyScreen(),
        ),
      ),

      GoRoute(
        path: AppPaths.edit_profile,
        name: AppRoutes.edit_profile,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: EditProfileScreen(),
        ),
      ),

      GoRoute(
        path: AppPaths.changePassword,
        name: AppRoutes.changePassword,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: const ChangePasswordScreen(),
        ),
      ),


      // GoRoute(
      //   path: '/communities',
      //   builder: (context, state) => const CommunityListScreen(),
      // ),
      // GoRoute(
      //   path: '/chat/:chatId',
      //   builder: (context, state) {
      //     final chatId = state.pathParameters['chatId']!;
      //     return ChatRoomScreen(chatId: chatId);
      //   },
      // ),
      // GoRoute(
      //   path: '/profile',
      //   builder: (context, state) => const ProfileScreen(),
      // ),

    ],
  );
});