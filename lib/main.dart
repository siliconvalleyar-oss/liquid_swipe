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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load saved theme preference
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('is_dark_theme') ?? true;
  final initialTheme = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(LiquidGlassApp(initialThemeMode: initialTheme));
}

/// Main application widget with theme and routing.
class LiquidGlassApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const LiquidGlassApp({super.key, required this.initialThemeMode});

  @override
  State<LiquidGlassApp> createState() => _LiquidGlassAppState();
}

class _LiquidGlassAppState extends State<LiquidGlassApp> {
  late ThemeMode _themeMode;
  bool _showTransitionOverlay = false;
  Color _overlayColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void _toggleTheme() {
    final newMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    // Capture OLD background color BEFORE switching _themeMode
    final oldBg = _themeMode == ThemeMode.dark
        ? AppTheme.darkBackground
        : AppTheme.lightBackground;

    // Show transition overlay with the old background, switch theme underneath,
    // then animate the radial reveal to uncover the new theme.
    setState(() {
      _overlayColor = oldBg;
      _showTransitionOverlay = true;
      _themeMode = newMode;
    });

    // Persist preference in background for next app launch
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('is_dark_theme', newMode == ThemeMode.dark);
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
