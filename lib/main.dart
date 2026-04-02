import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/env.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  runApp(const Society260App());
}

class Society260App extends StatefulWidget {
  const Society260App({super.key});

  @override
  State<Society260App> createState() => _Society260AppState();
}

class _Society260AppState extends State<Society260App> {
  @override
  void initState() {
    super.initState();
    ThemeController.instance.themeMode.addListener(_onThemeChange);
  }

  @override
  void dispose() {
    ThemeController.instance.themeMode.removeListener(_onThemeChange);
    super.dispose();
  }

  void _onThemeChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Society260',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeController.instance.themeMode.value,
      routerConfig: appRouter,
    );
  }
}
