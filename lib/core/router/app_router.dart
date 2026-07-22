import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/Features/Me/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:messageapp/Features/Me/presentation/screens/notifications/notification_list_screen.dart';
import 'package:messageapp/Features/Me/presentation/screens/notifications/notification_settings_screen.dart';
import 'package:messageapp/Features/Me/presentation/screens/security_privacy/security_privacy_screen.dart';
import 'package:messageapp/Features/ProductDetails/product_detals.dart';
import 'package:messageapp/Features/auth/presentation/screens/Auth/login_screen.dart';
import 'package:messageapp/Features/auth/presentation/screens/Auth/register_screen.dart';
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
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: ProductDetailsScreen(),
        ),
      ),

      GoRoute(
        path: AppPaths.search_product,
        name: AppRoutes.search_product,
        pageBuilder: (context, state) => buildSlideTransitionPage(
          key: state.pageKey,
          child: AnalysisDataScreen(),
        ),
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