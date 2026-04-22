# VoiceInk - Claude Code Instructions

Ei file Claude Code-ke project conventions janay. Notun feature implement korar age eta porte hobe.

## Project Overview

VoiceInk ekta Flutter mobile app — audio transcription, transcript editing, tappable word UI, and audio playback feature sho. Clean architecture pattern follow kora hoy.

## Architecture

### Clean Architecture — 8-File Pattern

Prottek feature-er jonno ei 8-file structure follow korte hobe:

1. **Model** (`lib/features/{feature}/data/models/{name}_model.dart`) — JSON serialization, extends Entity
2. **Entity** (`lib/features/{feature}/domain/entities/{name}_entity.dart`) — Pure business object
3. **Repository Interface** (`lib/features/{feature}/domain/repositories/{name}_repository.dart`) — Abstract class, returns `Either<Failure, T>`
4. **RepositoryImpl** (`lib/features/{feature}/data/repositories/{name}_repository_impl.dart`) — Implements interface, uses DataSource
5. **RemoteDataSource** (`lib/features/{feature}/data/datasources/{name}_remote_data_source.dart`) — DioClient call
6. **UseCase** (`lib/features/{feature}/domain/usecases/{action}_usecase.dart`) — Single action, calls repository
7. **Cubit** (`lib/features/{feature}/presentation/cubit/{name}_cubit.dart`) — Uses UseCase, emits State
8. **State** (`lib/features/{feature}/presentation/cubit/{name}_state.dart`) — Uses `NormalApiState` enum

### Nested Model Classes

Nested classes (jemon `Warehouse`, `CreatedByUser` inside a parent model) — egulo **plain data classes**, entity inheritance korbe na. Only top-level model entity extend korbe.

## API Conventions

### DioClient Usage

- **Always** use `APIRequestParam` object — raw string diye `DioClient` call korbe na
- `DioClient` returns `Either<Failure, Response>` — raw `Response` return korbe na
- Error handling `Either` pattern diye — Dartz `Left`/`Right`

### Endpoint Pattern

```dart
// Correct:
static const String login = '${baseUrl}v1/auth/login';

// Wrong:
static const String login = '/api/v1/auth/login';
```

Always `${baseUrl}v1/...` pattern use korte hobe `ApiEndPoints` class-e.

### Null Safety in fromJson

- Null coalescing operator (`??`) avoid korun bina kichu thought chara
- Explicit fallback values din
- Nullable fields `String?`, `int?` hishebe mark korun

## State Management

- **flutter_bloc / Cubit** — BLoC er perfect pattern
- State enum `NormalApiState` use kore — values: `loading`, `loaded`, `failure`, `initial`
- **Never** call `context.read<Cubit>()` inside async callbacks after widget might be disposed — Cubit-ke nijei state refresh manage korte din

## UI Conventions

- **Responsive:** `flutter_screenutil` use korun (`.sp`, `.h`, `.w`, `.r`)
- **Typography:** Google Fonts Inter
- **Theme:** Dark/light theme both support
- Tappable word UI **only** Editor tab-e — Transcript tab-e noy
- Dialog full-width korte `showGeneralDialog` ba `insetPadding` override korun — default `Dialog` width-limited
- `StatefulBuilder` use korun dialog-er moddhe real-time updates er jonno
- ExpansionTile accordion-e unique `Key` lagbe prottek tile-e — `initiallyExpanded` alone kaj kore na

## Dependency Injection

- DI files async `Future<void>` functions — `configureDependencies()` theke call hoy
- Notun feature add korle DI file update korun

## Release Build Issues

- fl_chart badge release-e strip hoye jete pare ProGuard/R8 due to — `minifyEnabled = false` use korun emergency-te
- `badgePositionPercentageOffset` — correct fl_chart API for badge positioning

## Code Style Preferences

- **Complete, copy-paste-ready code** din — explanatory comments chara (jodi na specifically chai)
- Reference existing screens follow korun — jemon "match the TranscriptDetailScreen pattern"
- Match existing UI reference files pixel-perfect

## Packages Used

- `flutter_bloc`, `dartz`, `dio`, `flutter_screenutil`
- `google_fonts`, `fl_chart`, `mobile_scanner`
- `cached_network_image`, `dotted_border` (v3.1.0)
- `file_picker`, `dart:io` (prefer over `http`)

## VoiceInk-Specific Context

### TranscriptDetailScreen Architecture

Split tab structure:
- **TranscriptTabWidget** — plain utterance text, tap to seek
- **EditorTabWidget** — tappable words, single-tap seek, double-tap edit, long-press options
  - Tip bar, speakers panel, instructions bar
  - Undo/redo toolbar
  - Large speaker avatars
  - Word options bottom sheet

### Known Fixes Applied

- Audio player safe init — `isClosed` checks add kora ache
- DioClient compatibility ensured
- DI file formatting correct

## Workflow Rules for Claude Code

1. **Notun feature er jonno:** Swagger link + web reference + existing screen reference din — ami full 8-file structure generate korbo
2. **Existing screen reference follow korun:** "Match PutAwayProductScreen pattern" erokom instruction din
3. **Review korben:** Generated code apnar convention-e ache kina check korun — especially prothom shoptaho
4. **Iterate korun:** Pattern mismatch hole ei file-e rule add korun
