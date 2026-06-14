import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/liquid_glass_bottom_bar.dart';
import 'widgets/theme_transition_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const LiquidGlassApp());
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
              // Pulsing logo icon
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
/// Shows a branded splash while loading the saved theme preference,
/// then transitions to the main app with navigation, theme toggle, etc.
class LiquidGlassApp extends StatefulWidget {
  const LiquidGlassApp({super.key});

  @override
  State<LiquidGlassApp> createState() => _LiquidGlassAppState();
}

class _LiquidGlassAppState extends State<LiquidGlassApp>
    with SingleTickerProviderStateMixin {
  static const List<ThemeMode> _themeCycle = [
    ThemeMode.dark,
    ThemeMode.light,
    ThemeMode.system,
  ];

  ThemeMode? _loadedThemeMode;
  late AnimationController _splashFadeController;

  // Theme toggle state
  late ThemeMode _themeMode;
  bool _showTransitionOverlay = false;
  Color _overlayColor = Colors.transparent;
  Offset _overlayOrigin = Offset.zero;

  @override
  void initState() {
    super.initState();
    _splashFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _themeMode = ThemeMode.dark; // temporary, will be overridden
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('theme_mode') ?? 'dark';
    final theme = switch (themeString) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };

    if (!mounted) return;

    // Fade out splash
    await _splashFadeController.forward();
    if (!mounted) return;

    setState(() {
      _loadedThemeMode = theme;
      _themeMode = theme;
    });
  }

  @override
  void dispose() {
    _splashFadeController.dispose();
    super.dispose();
  }

  Brightness _effectiveBrightness() {
    if (_themeMode == ThemeMode.dark) return Brightness.dark;
    if (_themeMode == ThemeMode.light) return Brightness.light;
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  void _toggleTheme([Offset? tapPosition]) {
    final currentIndex = _themeCycle.indexOf(_themeMode);
    final newMode = _themeCycle[(currentIndex + 1) % _themeCycle.length];

    // Capture OLD background color before switching
    final oldBrightness = _effectiveBrightness();
    final oldBg = oldBrightness == Brightness.dark
        ? AppTheme.darkBackground
        : AppTheme.lightBackground;

    // Persist preference
    final modeString = switch (newMode) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      _ => 'dark',
    };
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('theme_mode', modeString);
    });

    setState(() {
      _overlayColor = oldBg;
      _overlayOrigin = tapPosition ?? Offset.zero;
      _showTransitionOverlay = true;
      _themeMode = newMode;
    });
  }

  void _onTransitionComplete() {
    if (mounted) {
      setState(() {
        _showTransitionOverlay = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show branded splash while preferences are loading
    if (_loadedThemeMode == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: FadeTransition(
          opacity: _splashFadeController.drive(Tween(begin: 1.0, end: 0.0)),
          child: const _SplashBody(),
        ),
      );
    }

    // Main app once theme is loaded
    return ThemeModeProvider(
      themeMode: _themeMode,
      toggleTheme: _toggleTheme,
      child: MaterialApp(
        title: 'Liquid Glass',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        initialRoute: '/onboarding',
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/home': (context) => Builder(
                builder: (context) {
                  if (_showTransitionOverlay) {
                    return Stack(
                      children: [
                        const MainNavigationScreen(),
                        ThemeTransitionOverlay(
                          backgroundColor: _overlayColor,
                          origin: _overlayOrigin,
                          onComplete: _onTransitionComplete,
                        ),
                      ],
                    );
                  }
                  return const MainNavigationScreen();
                },
              ),
        },
      ),
    );
  }
}

/// Main navigation screen with the LiquidGlassBottomBar.
/// Manages 3 screens: Home, Notifications, and Profile.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  int _unreadNotificationCount = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      NotificationsScreen(
        onUnreadCountChanged: (count) {
          if (mounted) {
            setState(() {
              _unreadNotificationCount = count;
            });
          }
        },
      ),
      const ProfileScreen(),
    ];
  }

  final List<LiquidGlassBottomBarItem> _navItems = const [
    LiquidGlassBottomBarItem(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    LiquidGlassBottomBarItem(
      label: 'Notificaciones',
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
    ),
    LiquidGlassBottomBarItem(
      label: 'Perfil',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  void _onTabChanged(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: LiquidGlassBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        items: _navItems,
        badgeCounts: [0, _unreadNotificationCount, 0],
      ),
    );
  }
}
