import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messageapp/core/constants/asset_constants.dart';
import 'package:messageapp/Features/auth/presentation/providers/splash_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashProvider.notifier).startAnimation(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressColour = ref.watch(splashProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF0FDF4),
              const Color(0xFFF0FDF4),
            ],
          ),
        ),
        child: Stack(
          children: [

            Positioned(
                top: 0,
                right: 0,
                child: Image.asset("assets/images/Ellipse 86.png",)),
            Positioned(
                top: 0,
                left: 0,
                bottom: 50,
                right: 0,
                child: Image.asset(Assets.logo,)),

          ],
        ),
      ),
    );
  }
}
