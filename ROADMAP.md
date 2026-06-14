# 🗺️ Liquid Glass — Roadmap & Task Tracker

> **Proyecto:** `liquid_glass_app` · Flutter · v1.0.2  
> **Última actualización:** $(date +%Y-%m-%d)

---

## ✅ Completado (Base actual)

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
- [x] ThemeModeProvider (InheritedWidget) para acceso al tema
- [x] Orientación portrait fija
- [x] Skill Codebuff: deploy-to-mobile (build APK + ADB install)
- [x] Script build_and_install.sh para build release + instalación
- [x] Script bump_version.sh para versionado semántico

---

## ☐ Fase 1 — Fundamentos de Escalado

### ✅ Arquitectura y Estado Global
- [x] Migrar estado global a **Riverpod 3.x** (reemplazar InheritedWidget + setState por providers)
- [x] Separar por capas: `data/`, `domain/`, `presentation/`
- [x] Crear repositorios con interfaces para desacoplar la lógica de negocio (PreferencesRepository)
- [x] Inyectar dependencias con Riverpod (ya integrado)

### ☐ Navegación Avanzada
- [x] Migrar a **GoRouter** para navegación declarativa con deep linking
- [ ] Agregar rutas anidadas (ej: `home/feed`, `home/profile/edit`)
- [ ] Transiciones personalizadas entre rutas (Hero, shared axis)

### ✅ Testing
- [x] Widget tests para **GlassCard** (9 tests: render, padding, margin, gradientes, bordes, BackdropFilter)
- [x] Widget tests para **GlassButton** (6 tests: render, onTap, icon, null safety, BackdropFilter)
- [x] Widget tests para **LiquidBar** (10 tests: render, animación, progress 0/1, dispose, colores)
- [ ] Configurar `mockito` o `mocktail` para mocks
- [ ] Unit tests para modelos y lógica de negocio
- [x] Widget tests para **SquadWidget** (12 tests: render, labels, icons, BackdropFilter, ClipRRect, tap, dispose, custom params)
- [ ] Integration tests para flujo completo (onboarding → home)
- [ ] Golden tests para capturar regresiones visuales

---

## ☐ Fase 2 — Backend y Datos

### ☐ API y Backend
- [ ] Integrar **Firebase** o **Supabase** como backend
- [ ] Crear servicios REST/GraphQL con `dio` o `graphql_flutter`
- [ ] Cache offline con **Hive** o **Isar** + sync cuando hay conexión
- [ ] Manejo de errores con `Either` (dartz/fpdart) o Result type

### ☐ Autenticación
- [ ] Login/Register con Firebase Auth o Supabase Auth
- [ ] Providers OAuth (Google, Apple)
- [ ] Persistencia de sesión y refresh tokens
- [ ] Pantalla de login con animaciones glassmorphism

### ☐ Datos del Usuario
- [ ] Perfil de usuario editable (avatar, nombre, bio)
- [ ] Preferencias de usuario sincronizadas en la nube
- [ ] Historial de actividad persistente
- [ ] Configuración remota (feature flags)

---

## ☐ Fase 3 — Experiencia y Calidad

### ☐ Notificaciones Push
- [ ] Firebase Cloud Messaging (FCM)
- [ ] Deep links desde notificaciones
- [ ] Notification channels en Android
- [ ] Badge count en icono de la app

### ☐ Internacionalización (i18n)
- [ ] Soporte multi-idioma con `flutter_localizations` + `intl`
- [ ] Detección automática de locale del dispositivo
- [ ] Archivos ARB para traducciones
- [ ] Selector de idioma en settings

### ☐ Accesibilidad (a11y)
- [ ] Semantics labels en todos los widgets interactivos
- [ ] Soporte para lector de pantalla (TalkBack/VoiceOver)
- [ ] Contraste suficiente en modo claro/oscuro
- [ ] Tamaño de fuente dinámico

### ☐ Performance
- [ ] Lazy loading con `ListView.builder` en todas las listas
- [ ] Imágenes en caché con `cached_network_image`
- [ ] Shimmer loading skeletons
- [ ] Análisis de performance con DevTools + Flutter Inspector
- [ ] `RepaintBoundary` en widgets que se repintan frecuentemente

---

## ☐ Fase 4 — DevOps y Deploy

### ☐ CI/CD
- [ ] GitHub Actions para lint + test + build
- [ ] Fastlane para build automatizado + distribución (Play Store / TestFlight)
- [ ] CodeMagic o Codemagic CI para pipelines Flutter nativos
- [ ] Análisis estático con `dart analyze` + `custom_lint`

### ☐ Distribución
- [ ] Play Store — preparar store listing, screenshots, firma release
- [ ] App Store — preparar certificados, provisioning profiles
- [ ] Distribución interna con Firebase App Distribution
- [ ] Beta testing con TestFlight + Google Play Console

### ☐ Monitoreo
- [ ] Crash reporting con Firebase Crashlytics o Sentry
- [ ] Analytics con Firebase Analytics o Mixpanel
- [ ] Logging estructurado con `logging` package
- [ ] Remote config para cambios sin actualizar la app

---

## ☐ Fase 5 — Features Avanzadas

### ☐ UI/UX
- [ ] Modo tablet / responsive layout
- [ ] Modo landscape con layout adaptativo
- [ ] Temas personalizados por el usuario (colores, acentos)
- [ ] Modo "siempre oscuro" con schedule automático
- [ ] Refactor de animaciones a Rive para efectos más complejos
- [ ] Nuevos widgets: LiquidButton, LiquidProgress, LiquidSlider

### ☐ Social y Comunidad
- [ ] Feed de publicaciones con likes y comentarios
- [ ] Sistema de amigos / seguidores
- [ ] Chat en tiempo real con WebSockets o Firebase Realtime
- [ ] Compartir contenido con `share_plus`

### ☐ Gamificación
- [ ] Sistema de logros y badges
- [ ] Niveles de experiencia (XP) y leaderboards
- [ ] Desafíos diarios con recompensas
- [ ] Efectos visuales al completar logros (confetti, partículas)

### ☐ Multimedia
- [ ] Soporte para video (viajes, stories)
- [ ] Edición básica de imágenes
- [ ] Reproducción de audio con visualizador
- [ ] Cámara integrada con filtros

---

## 📈 Ideas para Escalar el Proyecto

### Estrategia General

1. **Evolución incremental** — No reescribir, sino migrar componente por componente. Cada PR agrega valor sin romper lo existente.
2. **Feature flags** — Usar remote config para activar/desactivar features sin redeploy.
3. **Modularización** — Extraer funcionalidades a paquetes independientes (`packages/`) cuando crezcan: `packages/liquid_ui`, `packages/liquid_core`, `packages/liquid_social`.
4. **Monorepo** con Melos — Para gestionar múltiples paquetes Flutter/Dart compartiendo configuración y scripts.

### Stack Recomendado (cuando crezca)

| Capa | Opción principal | Alternativa |
|------|-----------------|-------------|
| Estado | Riverpod 2.x | BLoC + flutter_bloc |
| Navegación | GoRouter | AutoRoute |
| Backend | Supabase (más económico) | Firebase |
| Base de datos local | Isar / Drift | Hive |
| HTTP | Dio | http + interceptors |
| Inyección | Riverpod | GetIt + Injectable |
| CI/CD | GitHub Actions + Fastlane | Codemagic |

### Próximos Pasos Recomendados (orden sugerido)

1. ☐ **Riverpod** — Migrar estado global (es la base para todo lo demás)
2. ☐ **Testing** — Agregar tests antes de refactorizar (seguridad)
3. ☐ **GoRouter** — Mejorar navegación con deep links y transiciones
4. ☐ **Firebase / Supabase** — Conectar backend para datos reales
5. ☐ **CI/CD** — Automatizar builds y tests

---

## 📝 Cómo usar este archivo

- **Marcar tarea completada**: cambiar `☐` por `✅` o `- [ ]` por `- [x]`
- **Agregar nueva tarea**: añadir una línea con `- [ ] Descripción`
- **Cada PR debería avanzar al menos una tarea**
- **Revisar este roadmap al inicio de cada sprint**

---

> 💡 **Tip:** Puedes pedirle a Codebuff que avance tareas de este roadmap.  
> Solo dile algo como: *"Avanzar tarea de Riverpod del ROADMAP"*
