import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        prefsProvider.overrideWithValue(prefs),
      ],
      child: const LiquidGlassApp(),
    ),
  );
}

/// Static splash body widget shown while preferences load.
class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D0D2B), Color(0xFF1A1A3E), Color(0xFF0D0D2B)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6C63FF).withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.water_drop, color: Colors.white, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Liquid Glass',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cargando…',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Root application widget.
///
/// Shows a branded splash while loading the saved theme preference,
/// then transitions to the main app with GoRouter navigation.
class LiquidGlassApp extends ConsumerStatefulWidget {
  const LiquidGlassApp({super.key});

  @override
  ConsumerState<LiquidGlassApp> createState() => _LiquidGlassAppState();
}

class _LiquidGlassAppState extends ConsumerState<LiquidGlassApp>
    with SingleTickerProviderStateMixin {
  bool _loaded = false;
  late AnimationController _splashFadeController;

  @override
  void initState() {
    super.initState();
    _splashFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      ref.read(themeModeProvider.notifier).loadFromPrefs();
    } catch (_) {
      // If prefs fail, still continue to main app
    }
    if (!mounted) return;

    // Wait for fade animation (max 3 seconds as safety net)
    await _splashFadeController.forward().timeout(
      const Duration(seconds: 3),
      onTimeout: () => _splashFadeController.value = 1.0,
    );
    if (!mounted) return;

    setState(() {
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _splashFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: FadeTransition(
          opacity: _splashFadeController.drive(Tween(begin: 1.0, end: 0.0)),
          child: const _SplashBody(),
        ),
      );
    }

    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Liquid Glass',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
