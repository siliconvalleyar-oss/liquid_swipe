# 📋 TODO — Liquid Glass App

> **Proyecto:** `liquid_glass_app` · Flutter · v1.0.3
> Estado actual del proyecto y próximos pasos.

---

## 🚧 En Progreso

- [ ] Conectar Supabase como backend (pendiente de crear proyecto)

---

## 📱 Navegación (GoRouter)

- [x] Migrar a GoRouter con StatefulShellRoute
- [x] Agregar rutas anidadas: `/home/profile/edit` y `/home/notifications/:id`
- [x] Transiciones animadas entre rutas (slide+fade con CustomTransitionPage)
- [x] Pantalla de detalle de notificación (NotificationDetailScreen)
- [x] Pantalla de edición de perfil (ProfileEditScreen)
- [ ] Deep linking

---

## 🔌 Backend y Datos

- [ ] Crear proyecto en Supabase y obtener credenciales
- [ ] Integrar Supabase Flutter SDK
- [ ] Crear servicios REST con `supabase_flutter`
- [ ] Cache offline con Hive o Isar
- [ ] Sincronización cuando hay conexión
- [ ] Manejo de errores con Result type

---

## 🔐 Autenticación

- [ ] Login/Register con Supabase Auth
- [ ] Providers OAuth (Google, Apple)
- [ ] Persistencia de sesión y refresh tokens
- [ ] Pantalla de login con animaciones glassmorphism

---

## 👤 Datos del Usuario

- [ ] Perfil de usuario editable (avatar, nombre, bio)
- [ ] Preferencias de usuario sincronizadas en la nube
- [ ] Historial de actividad persistente
- [ ] Configuración remota (feature flags)

---

## 🧪 Testing

- [x] Widget tests para GlassCard (9 tests)
- [x] Widget tests para GlassButton (6 tests)
- [x] Widget tests para LiquidBar (10 tests)
- [x] Widget tests para SquadWidget (12 tests)
- [ ] Configurar mockito o mocktail para mocks
- [ ] Unit tests para modelos y lógica de negocio
- [ ] Widget tests para ProfileScreen, NotificationsScreen, HomeScreen
- [ ] Integration tests para flujo completo (onboarding → home)
- [ ] Golden tests para capturar regresiones visuales

---

## 🌐 Internacionalización (i18n)

- [ ] Soporte multi-idioma con flutter_localizations + intl
- [ ] Detección automática de locale del dispositivo
- [ ] Archivos ARB para traducciones
- [ ] Selector de idioma en settings

---

## ♿ Accesibilidad (a11y)

- [ ] Semantics labels en todos los widgets interactivos
- [ ] Soporte para lector de pantalla (TalkBack/VoiceOver)
- [ ] Contraste suficiente en modo claro/oscuro
- [ ] Tamaño de fuente dinámico

---

## ⚡ Performance

- [ ] Lazy loading con ListView.builder en todas las listas
- [ ] Imágenes en caché con cached_network_image
- [ ] Shimmer loading skeletons
- [ ] Análisis de performance con DevTools + Flutter Inspector
- [ ] RepaintBoundary en widgets que se repintan frecuentemente

---

## 🚀 CI/CD

- [ ] GitHub Actions para lint + test + build
- [ ] Fastlane para build automatizado + distribución
- [ ] CodeMagic o Codemagic CI para pipelines Flutter nativos

---

## 📦 Distribución

- [ ] Play Store — preparar store listing, screenshots, firma release
- [ ] App Store — preparar certificados, provisioning profiles
- [ ] Distribución interna con Firebase App Distribution
- [ ] Beta testing con TestFlight + Google Play Console

---

## 📊 Monitoreo

- [ ] Crash reporting con Firebase Crashlytics o Sentry
- [ ] Analytics con Firebase Analytics o Mixpanel
- [ ] Logging estructurado con logging package
- [ ] Remote config para cambios sin actualizar la app

---

## 🎨 UI/UX Avanzado

- [ ] Modo tablet / responsive layout
- [ ] Modo landscape con layout adaptativo
- [ ] Temas personalizados por el usuario (colores, acentos)
- [ ] Modo "siempre oscuro" con schedule automático
- [ ] Refactor de animaciones a Rive para efectos más complejos
- [ ] Nuevos widgets: LiquidButton, LiquidProgress, LiquidSlider

---

## 👥 Social y Comunidad

- [ ] Feed de publicaciones con likes y comentarios
- [ ] Sistema de amigos / seguidores
- [ ] Chat en tiempo real con WebSockets o Supabase Realtime
- [ ] Compartir contenido con share_plus

---

## 🎮 Gamificación

- [ ] Sistema de logros y badges
- [ ] Niveles de experiencia (XP) y leaderboards
- [ ] Desafíos diarios con recompensas
- [ ] Efectos visuales al completar logros (confetti, partículas)

---

## 📹 Multimedia

- [ ] Soporte para video (viajes, stories)
- [ ] Edición básica de imágenes
- [ ] Reproducción de audio con visualizador
- [ ] Cámara integrada con filtros

---

## ✅ Completado

- [x] App scaffold con splash animado y carga de preferencias
- [x] Onboarding con LiquidSwipe (3 páginas, efecto ola)
- [x] Home screen con header, glassmorphism cards y stats
- [x] Feature carousel con PageView + smooth_page_indicator + auto-scroll
- [x] LiquidBar widget con animación de ola deformable
- [x] Squad widget con animaciones escalonadas y rebote sincronizado
- [x] Profile screen con perfil, achievements grid, skill bars animadas
- [x] Notifications screen con badges, dismiss, mark all read
- [x] LiquidGlassBottomBar con efecto glassmorphism + badges animados
- [x] Tema dark/light/system con persistencia en SharedPreferences
- [x] ThemeTransitionOverlay con reveal radial al cambiar tema
- [x] GlassmorphismWidget reutilizable (GlassCard, GlassButton)
- [x] Orientación portrait fija
- [x] Script build_and_install.sh para build release + instalación
- [x] Script bump_version.sh para versionado semántico
- [x] Migrar estado global a Riverpod 3.x
- [x] Separar por capas: data/, domain/, presentation/
- [x] Crear repositorios con interfaces (PreferencesRepository)
- [x] Migrar a GoRouter para navegación declarativa
- [x] Widget tests para GlassCard, GlassButton, LiquidBar, SquadWidget
- [x] Icono de la app generado (SVG + PNG + Android/iOS mipmap)
- [x] Build e instalación v1.0.3 en dispositivo móvil
