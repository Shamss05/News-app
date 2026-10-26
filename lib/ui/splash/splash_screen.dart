import 'dart:async';
import 'package:flutter/material.dart';
import 'package:assignment_7/core/providers/app_config_provider.dart';
import 'package:assignment_7/ui/home/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer( Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.asset("assets/images/${provider.isDarkMode ? "dark" : "light"}/news_logo.png",),),
          Image.asset("assets/images/${provider.isDarkMode ? "dark" : "light"}/news_branding.png", width: MediaQuery.sizeOf(context).width * 0.6,),
        ],
      ),
    );
  }
}
