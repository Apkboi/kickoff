# KickOff — Cursor Rules
# Place this file as `.cursorrules` in the root of the Flutter project

You are an expert Flutter developer working on the KickOff app — a sports competition and tournament management platform. The stack is Flutter + BLoC + Firebase with clean architecture and a feature-first folder structure.

---

## Project context

- App name: KickOff
- Platform: Flutter (mobile + web + desktop, fully responsive)
- State management: flutter_bloc (BLoC pattern only, no Cubit unless trivial UI state)
- Backend: Firebase (Firestore, Auth, Storage, Messaging, Cloud Functions)
- DI: get_it + injectable
- Navigation: go_router
- Error handling: dartz Either type (Left = Failure, Right = data)
- Theme: dual light/dark theme with AppColors constants — never hardcode hex values in widgets

---

## Architecture rules

- Always follow clean architecture: data → domain → presentation layers per feature
- Domain layer has zero Flutter/Firebase imports — pure Dart only
- Data layer implements domain repository interfaces
- Presentation layer contains only BLoC + screens + widgets
- UseCases are single-responsibility: one public `call()` method, takes a Params class
- Repository interfaces live in domain/repositories/, implementations in data/repositories/
- Models (data layer) extend or implement entities (domain layer)
- Models handle fromJson/toJson and fromFirestore/toFirestore — entities do not

---

## BLoC rules

- Every BLoC has: Initial, Loading, Loaded, Error states minimum
- All states and events extend Equatable
- Never use `emit()` inside a `then()` callback — always await
- Real-time Firestore streams: use `on<EventName>` with `emit.forEach` or stream subscription stored in BLoC, cancelled in `close()`
- Never expose Firestore streams directly to widgets — always proxy through BLoC
- BLoC files: `feature_bloc.dart`, `feature_event.dart`, `feature_state.dart`

```dart
// Correct BLoC stream pattern
StreamSubscription<List<MatchEntity>>? _matchSub;

on<WatchLiveMatchesStarted>((event, emit) async {
  _matchSub?.cancel();
  _matchSub = _watchLiveMatches().listen(
    (matches) => add(LiveMatchesUpdated(matches)),
  );
});

on<LiveMatchesUpdated>((event, emit) {
  emit(HomeLoaded(liveMatches: event.matches));
});

@override
Future<void> close() {
  _matchSub?.cancel();
  return super.close();
}
```

---

## Firebase rules

- Always use `.withConverter()` on Firestore references — never raw `Map<String, dynamic>`
- All Firestore writes must include `createdAt: FieldValue.serverTimestamp()` on creation
- Never store sensitive logic in client — use Cloud Functions for: standings recalculation, score validation, notification dispatch
- Firestore queries must have indexes defined before use — note required indexes in a comment above the query
- Always handle `FirebaseException` in datasources and convert to domain Failures
- Real-time listeners: always cancel subscriptions in BLoC `close()` or widget `dispose()`
- Storage uploads: compress images before upload (max 512KB for avatars, 1MB for banners)

```dart
// Correct Firestore converter pattern
final matchRef = FirebaseFirestore.instance
    .collection('matches')
    .withConverter<MatchModel>(
      fromFirestore: (snap, _) => MatchModel.fromFirestore(snap),
      toFirestore: (model, _) => model.toFirestore(),
    );
```

---

## Responsive layout rules

- Always check `Responsive.isDesktop(context)` / `isMobile()` — never use raw `MediaQuery` width comparisons in widgets
- Desktop (≥1024px): persistent left sidebar (260px) + content area
- Mobile (<600px): bottom navigation bar (5 tabs) + full screen content
- Tablet (600–1024px): NavigationRail (left) + content
- `AppScaffold` widget handles the shell — never build nav directly in screens
- All cards must use `LayoutBuilder` or `Flexible`/`Expanded` — never hardcode pixel widths in cards

---

## Theme and styling rules

- NEVER hardcode color hex values in widget files
- Always use `AppColors.accentGreen`, `AppColors.backgroundCard`, etc.
- Always use `AppTextStyles.heading1`, `AppTextStyles.bodySmall`, etc.
- Use `AppSpacing.md` (16), `AppSpacing.sm` (8), `AppSpacing.lg` (24) — never raw pixel numbers for spacing
- Border radius: `AppRadius.card` (16), `AppRadius.button` (12), `AppRadius.pill` (100)
- Theme is accessed via `Theme.of(context)` for standard tokens, `AppColors.of(context)` for custom tokens

```dart
// Correct
Container(
  color: AppColors.backgroundCard(context),
  padding: EdgeInsets.all(AppSpacing.md),
  child: Text('Hello', style: AppTextStyles.bodyMedium(context)),
)

// Wrong — never do this
Container(
  color: Color(0xFF1E3320),
  padding: EdgeInsets.all(16),
)
```

---

## Widget rules

- Screens are dumb — they only contain BlocBuilder/BlocListener and pass data down to widgets
- Extract any widget over ~40 lines into its own file under `presentation/widgets/`
- Shared widgets used in 2+ features go in `shared/widgets/`
- Always add `const` constructors where possible
- Use `key` parameter on list items — always `ValueKey(entity.id)`
- Loading states use `LoadingShimmer` widget — never a raw `CircularProgressIndicator` in cards
- Error states always show a retry button that re-dispatches the original event

---

## Naming conventions

| Type | Convention | Example |
|---|---|---|
| Files | snake_case | `match_detail_screen.dart` |
| Classes | PascalCase | `MatchDetailScreen` |
| BLoC events | PastTense or Imperative noun | `MatchDetailLoaded`, `ScoreUpdateSubmitted` |
| BLoC states | Descriptive noun | `MatchDetailState`, `ScoreUpdateSuccess` |
| UseCases | VerbNounUseCase | `UpdateScoreUseCase` |
| Entities | NounEntity | `MatchEntity` |
| Models | NounModel | `MatchModel` |
| Repositories (interface) | NounRepository | `MatchRepository` |
| Repositories (impl) | NounRepositoryImpl | `MatchRepositoryImpl` |

---

## File generation rules

When generating a new feature, always create ALL of these files together:
1. `domain/entities/noun_entity.dart`
2. `domain/repositories/noun_repository.dart`
3. `domain/usecases/verb_noun_usecase.dart`
4. `data/models/noun_model.dart`
5. `data/datasources/noun_remote_datasource.dart`
6. `data/repositories/noun_repository_impl.dart`
7. `presentation/bloc/noun_bloc.dart` + `noun_event.dart` + `noun_state.dart`
8. `presentation/screens/noun_screen.dart`

Never generate a screen without its corresponding BLoC. Never generate a BLoC without its usecase.

---

## Error handling pattern

```dart
// Datasource — throws exceptions
Future<MatchModel> getMatch(String id) async {
  try {
    final doc = await matchRef.doc(id).get();
    if (!doc.exists) throw MatchNotFoundException();
    return doc.data()!;
  } on FirebaseException catch (e) {
    throw FirebaseDataException(e.message);
  }
}

// Repository — converts to Either
Future<Either<Failure, MatchEntity>> getMatch(String id) async {
  try {
    final model = await _datasource.getMatch(id);
    return Right(model.toEntity());
  } on MatchNotFoundException {
    return Left(NotFoundFailure());
  } on FirebaseDataException catch (e) {
    return Left(ServerFailure(e.message));
  }
}

// BLoC — handles Either
on<MatchDetailRequested>((event, emit) async {
  emit(MatchDetailLoading());
  final result = await _getMatch(GetMatchParams(id: event.matchId));
  result.fold(
    (failure) => emit(MatchDetailError(failure.message)),
    (match) => emit(MatchDetailLoaded(match)),
  );
});
```

---

## Admin access control

- Admin-only widgets must check `context.read<AuthBloc>().state.user.iscompetitionAdmin(competitionId)`
- Admin-only screens must be guarded in go_router with a redirect
- Score update operations must verify admin status in BOTH the client and Firestore security rules
- Never show admin controls to non-admins — use `Visibility` or conditional rendering, not route guards alone

---

## What NOT to do

- Do NOT use `setState` for business logic — only for trivial local UI state (e.g. a toggle animation)
- Do NOT use `context.read<Bloc>()` inside `build()` — use `BlocBuilder` or `BlocSelector`
- Do NOT call `Navigator.push` directly — always use `context.go()` or `context.push()` from go_router
- Do NOT write Firestore queries inline in widgets or BLoCs — always go through the data layer
- Do NOT use `dynamic` types anywhere — always type explicitly
- Do NOT import Firebase packages in the domain layer
- Do NOT create God widgets — if a widget file exceeds 150 lines, split it
- Do NOT skip error states — every BlocBuilder must handle all states explicitly
- Do NOT use `print()` — use a proper logger (e.g. `logger` package)
- Do NOT hardcode user IDs, collection names, or field names as raw strings in multiple places — define them in constants

---

## go_router rules

- Always define route paths as constants in `AppRoutes` — never use raw strings in `context.go()` or `context.push()`
- Always use `StatefulShellRoute.indexedStack` for the bottom nav / sidebar shell — never manage nav index with setState
- Route parameters are accessed via `state.pathParameters['key']` — always null-check or use `!` with confidence
- For programmatic navigation use `context.go()` to replace stack, `context.push()` to add to stack — never `Navigator.push`
- The auth guard lives in `RouterGuards.authGuard` — never duplicate redirect logic anywhere else
- Full-screen routes (match detail, admin score) sit outside the `StatefulShellRoute` so they cover the nav bar
- Sub-routes (standings, bracket, edit profile) are nested under their parent `GoRoute` using the `routes:` parameter
- Pass data between routes via path parameters for IDs, and `extra:` only for non-serializable objects
- Never pass entire entity objects via `extra:` — always pass the ID and fetch in the destination screen's BLoC

```dart
// Correct — pass ID only
context.push('/competitions/${competition.id}');

// Correct — named route with params
context.goNamed('matchDetail', pathParameters: {'matchId': match.id});

// Wrong — never pass object via extra for primary data
context.push('/matches/detail', extra: matchEntity);
```
