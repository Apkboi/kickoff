# KickOff — Flutter Development Plan
**Stack:** Flutter · BLoC · Firebase · Feature-first Clean Architecture

---

## Color System (from UI screens)

### Dark Mode
| Token | Hex |
|---|---|
| Background primary | `#0D1B0F` |
| Background surface | `#1A2E1C` |
| Background card | `#1E3320` |
| Accent green | `#00E676` |
| Accent green muted | `#1D9E75` |
| Text primary | `#FFFFFF` |
| Text secondary | `#A0B8A2` |
| Border subtle | `#2A4A2C` |
| Live badge | `#FF4444` |

### Light Mode
| Token | Hex |
|---|---|
| Background primary | `#F4F6F4` |
| Background surface | `#FFFFFF` |
| Background card | `#FFFFFF` |
| Accent green | `#1A7A3C` |
| Accent green muted | `#1D9E75` |
| Text primary | `#0D1B0F` |
| Text secondary | `#5A7A5C` |
| Border subtle | `#E0EAE0` |
| Sidebar dark | `#0D2B14` |

---

## Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_spacing.dart
│   ├── di/
│   │   └── injection.dart              # get_it + injectable
│   ├── error/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── firebase/
│   │   └── firebase_config.dart
│   ├── router/
│   │   ├── app_router.dart             # GoRouter instance + all routes
│   │   ├── app_routes.dart             # Route name constants
│   │   └── router_guards.dart          # redirect logic (auth guard)
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── dark_theme.dart
│   │   └── light_theme.dart
│   └── utils/
│       ├── date_utils.dart
│       └── responsive.dart             # breakpoints helper
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_usecase.dart
│   │   │       ├── sign_up_usecase.dart
│   │   │       ├── sign_in_google_usecase.dart
│   │   │       └── sign_out_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       └── screens/
│   │           ├── onboarding_screen.dart
│   │           ├── sign_in_screen.dart
│   │           └── sign_up_screen.dart
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── home_bloc.dart
│   │       │   ├── home_event.dart
│   │       │   └── home_state.dart
│   │       ├── screens/
│   │       │   └── home_screen.dart
│   │       └── widgets/
│   │           ├── featured_match_card.dart
│   │           ├── live_match_tile.dart
│   │           ├── upcoming_fixture_tile.dart
│   │           ├── competition_mini_card.dart
│   │           ├── personal_stats_card.dart
│   │           └── highlights_row.dart
│   │
│   ├── competition/
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── competition_bloc.dart
│   │       │   ├── competition_event.dart
│   │       │   └── competition_state.dart
│   │       ├── screens/
│   │       │   ├── my_competitions_screen.dart
│   │       │   ├── competition_detail_screen.dart
│   │       │   └── create_competition_screen.dart
│   │       └── widgets/
│   │           ├── bracket_widget.dart
│   │           ├── standings_table.dart
│   │           └── player_card.dart
│   │
│   ├── match/
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── match_bloc.dart
│   │       │   ├── match_event.dart
│   │       │   └── match_state.dart
│   │       ├── screens/
│   │       │   ├── match_detail_screen.dart
│   │       │   └── admin_score_screen.dart
│   │       └── widgets/
│   │           ├── score_header.dart
│   │           ├── match_timeline.dart
│   │           └── admin_score_controls.dart
│   │
│   ├── calendar/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       │   └── calendar_screen.dart
│   │       └── widgets/
│   │           ├── date_strip.dart
│   │           └── fixture_card.dart
│   │
│   ├── explore/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       │   └── explore_screen.dart
│   │       └── widgets/
│   │           └── search_result_card.dart
│   │
│   └── profile/
│       └── presentation/
│           ├── bloc/
│           ├── screens/
│           │   └── profile_screen.dart
│           └── widgets/
│               ├── stats_row.dart
│               └── sport_stat_card.dart
│
├── shared/
│   ├── widgets/
│   │   ├── app_scaffold.dart           # responsive shell (sidebar + bottom nav)
│   │   ├── live_badge.dart
│   │   ├── status_pill.dart
│   │   ├── avatar_circle.dart
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   └── loading_shimmer.dart
│   └── models/
│       └── paginated_result.dart
│
└── main.dart
```

> **UI-first note:** `data/` and `domain/` layers are intentionally omitted from
> each feature during Phase 1. You build every screen and widget with hardcoded
> mock data first. Data layers are added in Phase 2 once all UIs are approved.

---

## go_router Setup

### Route name constants — `core/router/app_routes.dart`

```dart
abstract class AppRoutes {
  // Auth
  static const splash      = '/';
  static const onboarding  = '/onboarding';
  static const signIn      = '/sign-in';
  static const signUp      = '/sign-up';

  // Shell (bottom nav / sidebar)
  static const home        = '/home';
  static const explore     = '/explore';
  static const myCompetitions = '/my-competitions';
  static const calendar    = '/calendar';
  static const profile     = '/profile';

  // Competition
  static const createCompetition      = '/competitions/create';
  static const competitionDetail      = '/competitions/:competitionId';
  static const competitionStandings   = '/competitions/:competitionId/standings';
  static const competitionBracket     = '/competitions/:competitionId/bracket';
  static const competitionPlayers     = '/competitions/:competitionId/players';

  // Match
  static const matchDetail   = '/matches/:matchId';
  static const adminScore    = '/matches/:matchId/score';

  // Profile
  static const editProfile   = '/profile/edit';
  static const notifications = '/profile/notifications';
}
```

### Router instance — `core/router/app_router.dart`

```dart
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: RouterGuards.authGuard,   // see guards below
    routes: [

      // ── Auth routes (no shell) ──────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (_, __) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (_, __) => const SignUpScreen(),
      ),

      // ── Shell (persistent nav) ──────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppScaffold(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, __) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.explore,
              builder: (_, __) => const ExploreScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.myCompetitions,
              builder: (_, __) => const MyCompetitionsScreen(),
              routes: [
                GoRoute(
                  path: 'create',
                  builder: (_, __) => const CreateCompetitionScreen(),
                ),
                GoRoute(
                  path: ':competitionId',
                  builder: (ctx, state) => CompetitionDetailScreen(
                    competitionId: state.pathParameters['competitionId']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'standings',
                      builder: (ctx, state) => StandingsScreen(
                        competitionId: state.pathParameters['competitionId']!,
                      ),
                    ),
                    GoRoute(
                      path: 'bracket',
                      builder: (ctx, state) => BracketScreen(
                        competitionId: state.pathParameters['competitionId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.calendar,
              builder: (_, __) => const CalendarScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (_, __) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (_, __) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  builder: (_, __) => const NotificationsScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),

      // ── Match routes (outside shell — full screen) ──────────
      GoRoute(
        path: AppRoutes.matchDetail,
        builder: (ctx, state) => MatchDetailScreen(
          matchId: state.pathParameters['matchId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.adminScore,
        builder: (ctx, state) => AdminScoreScreen(
          matchId: state.pathParameters['matchId']!,
        ),
      ),
    ],
  );
});
```

### Auth guard — `core/router/router_guards.dart`

```dart
abstract class RouterGuards {
  static const _publicRoutes = [
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.signIn,
    AppRoutes.signUp,
  ];

  static String? authGuard(BuildContext context, GoRouterState state) {
    final isLoggedIn = context.read<AuthBloc>().state is AuthAuthenticated;
    final isPublic = _publicRoutes.contains(state.matchedLocation);

    if (!isLoggedIn && !isPublic) return AppRoutes.signIn;
    if (isLoggedIn && isPublic)  return AppRoutes.home;
    return null;
  }
}
```

### Navigation usage in widgets

```dart
// Push
context.push(AppRoutes.matchDetail.replaceFirst(':matchId', match.id));

// Go (replace stack)
context.go(AppRoutes.home);

// Go with params helper
context.goNamed('competitionDetail', pathParameters: {'competitionId': id});

// Pop
context.pop();
```

---

## Firebase Architecture

### Collections

```
users/{userId}
  - uid: string
  - displayName: string
  - email: string
  - photoUrl: string?
  - role: 'player' | 'admin' | 'super_admin'
  - createdAt: timestamp
  - xpPoints: number
  - membershipTier: 'free' | 'pro'   // placeholder, not active yet

competitions/{competitionId}
  - name: string
  - sport: string
  - format: 'league' | 'knockout' | 'group_knockout'
  - status: 'upcoming' | 'active' | 'completed'
  - privacy: 'public' | 'invite_only'
  - createdBy: userId
  - adminIds: string[]
  - maxTeams: number
  - currentTeams: number
  - startDate: timestamp
  - endDate: timestamp?
  - prizePool: number?
  - logoUrl: string?
  - bannerUrl: string?
  - createdAt: timestamp

competitions/{competitionId}/teams/{teamId}
  - name: string
  - logoUrl: string?
  - captainId: userId
  - playerIds: string[]
  - createdAt: timestamp

competitions/{competitionId}/standings/{teamId}
  - teamId: string
  - teamName: string
  - played: number
  - won: number
  - drawn: number
  - lost: number
  - goalsFor: number
  - goalsAgainst: number
  - points: number

matches/{matchId}
  - competitionId: string
  - homeTeamId: string
  - awayTeamId: string
  - homeTeamName: string
  - awayTeamName: string
  - homeScore: number
  - awayScore: number
  - status: 'scheduled' | 'live' | 'completed' | 'cancelled'
  - scheduledAt: timestamp
  - startedAt: timestamp?
  - completedAt: timestamp?
  - round: string?
  - venue: string?
  - streamUrl: string?
  - adminIds: string[]
  - minute: number?

notifications/{notificationId}
  - userId: string
  - type: 'match_reminder' | 'score_update' | 'competition_invite'
  - title: string
  - body: string
  - read: boolean
  - createdAt: timestamp
  - payload: map
```

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isAuth() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isCompetitionAdmin(competitionId) {
      return isAuth() &&
        request.auth.uid in get(/databases/$(database)/documents/competitions/$(competitionId)).data.adminIds;
    }

    function isCompetitionCreator(competitionId) {
      return isAuth() &&
        request.auth.uid == get(/databases/$(database)/documents/competitions/$(competitionId)).data.createdBy;
    }

    match /users/{userId} {
      allow read: if isAuth();
      allow create: if isOwner(userId);
      allow update: if isOwner(userId);
      allow delete: if false;
    }

    match /competitions/{competitionId} {
      allow read: if isAuth();
      allow create: if isAuth();
      allow update: if isCompetitionCreator(competitionId) || isCompetitionAdmin(competitionId);
      allow delete: if isCompetitionCreator(competitionId);

      match /teams/{teamId} {
        allow read: if isAuth();
        allow write: if isCompetitionCreator(competitionId) || isCompetitionAdmin(competitionId);
      }

      match /standings/{teamId} {
        allow read: if isAuth();
        allow write: if isCompetitionCreator(competitionId) || isCompetitionAdmin(competitionId);
      }
    }

    match /matches/{matchId} {
      allow read: if isAuth();
      allow create: if isAuth() && isCompetitionCreator(resource.data.competitionId);
      allow update: if isCompetitionAdmin(resource.data.competitionId) ||
                       isCompetitionCreator(resource.data.competitionId);
      allow delete: if isCompetitionCreator(resource.data.competitionId);
    }

    match /notifications/{notificationId} {
      allow read: if isOwner(resource.data.userId);
      allow create: if isAuth();
      allow update: if isOwner(resource.data.userId);
      allow delete: if isOwner(resource.data.userId);
    }
  }
}
```

---

## Key Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  equatable: ^2.0.5

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  firebase_messaging: ^14.7.10

  # Navigation
  go_router: ^13.2.0

  # DI
  get_it: ^7.6.7
  injectable: ^2.3.2

  # Error handling
  dartz: ^0.10.1

  # Network
  internet_connection_checker: ^1.0.0+1

  # UI
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  fl_chart: ^0.67.0
  intl: ^0.19.0

  # Auth
  google_sign_in: ^6.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mocktail: ^1.0.2
  injectable_generator: ^2.4.1
  build_runner: ^2.4.8
```

---

## Responsive Layout Strategy

```dart
// core/utils/responsive.dart
class Responsive {
  static bool isMobile(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width < 600;
  static bool isTablet(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= 600 &&
      MediaQuery.of(ctx).size.width < 1024;
  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= 1024;
}

// shared/widgets/app_scaffold.dart
// Receives StatefulNavigationShell from go_router
// - Desktop (≥1024px): Row( SidebarNav(260px) + Expanded(shell) )
// - Tablet  (600–1024): Row( NavigationRail(72px) + Expanded(shell) )
// - Mobile  (<600px):  Scaffold( body: shell, bottomNavigationBar: BottomNav )
```

---

## BLoC Pattern Convention

```
Event  →  BLoC  →  State
                    ├── Initial
                    ├── Loading
                    ├── Loaded(data)
                    └── Error(message)
```

Real-time Firestore streams go through BLoC only — never exposed directly to widgets.

---

## Development Phases

---

### PHASE 1 — UI Only (Days 1–8)
> Goal: every screen pixel-perfect with mock data. No Firebase. No BLoC business logic.
> Use simple static data classes in `presentation/` only during this phase.

#### Days 1–2 — Foundation
- Flutter project, folder structure
- `app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart`
- Light + dark theme wired to `ThemeMode`
- `responsive.dart` breakpoint helper
- go_router full setup (`app_routes.dart`, `app_router.dart`, `router_guards.dart`)
- `AppScaffold` — sidebar (desktop) + bottom nav (mobile) shell using `StatefulShellRoute`
- Splash screen

#### Days 3–4 — Auth + Home UI
- Onboarding (3 slides)
- Sign in / Sign up screens
- Home screen with all sections:
  - Featured match hero card (hardcoded)
  - Live matches row
  - Upcoming fixtures row
  - My competitions mini cards
  - Personal stats card
  - Highlights row

#### Days 5–6 — Competition + Match UI
- My competitions screen
- Competition detail screen (tabs: Overview / Bracket / Standings / Players)
- Standings table widget
- Bracket widget
- Create competition screen (multi-step form)
- Match detail screen (score header + match info)
- Admin score screen (score controls, status toggle)

#### Days 7–8 — Calendar + Explore + Profile UI
- Calendar screen (date strip + fixture cards)
- Explore screen (search bar + result cards)
- Profile screen (avatar, XP bar, stats, sport cards)
- Edit profile screen
- Notifications screen

---

### PHASE 2 — Logic + Firebase (Days 9–14)
> Goal: replace all mock data with real Firestore streams through BLoC.

#### Days 9–10 — Auth + Data layers
- Firebase project setup (dev + prod)
- Add `data/` + `domain/` layers to all features
- Firebase Auth (email + Google)
- AuthBloc wired to go_router guard
- User document creation on sign-up

#### Days 11–12 — Home + Competition + Match logic
- Firestore streams for live matches, upcoming fixtures
- HomeBloc, CompetitionBloc, MatchBloc
- Admin score update → Firestore write
- Real-time score on match detail screen

#### Days 13–14 — Calendar + Explore + Polish
- CalendarBloc — fixtures by date
- ExploreBloc — search competitions + players
- ProfileBloc — user stats
- FCM push notifications for match reminders
- Loading shimmer states
- Error states + retry everywhere
- TestFlight (iOS) + Play Store internal track

---

## Cloud Functions

```
functions/
├── src/
│   ├── onMatchComplete.ts   // recalculate standings when match → completed
│   └── onScoreUpdate.ts     // FCM push to competition followers on score change
```

---

## Cursor Rules

See `.cursorrules` file in project root.
