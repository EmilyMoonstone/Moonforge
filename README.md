<div>

# Moonforge

<img src="moonforge/assets/images/forge.png" alt="Moonforge Hero" width="100%" style="height: 200px; max-height: 200px; object-fit: cover; object-position: center; border-radius: 8px; margin-bottom: 20px; display: block;">

<p>
  <a href="https://flutter.dev"><img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white"></a>
  <a href="https://dart.dev"><img alt="Dart" src="https://img.shields.io/badge/Dart-3.10-0175C2?logo=dart&logoColor=white"></a>
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
  <img alt="Platforms" src="https://img.shields.io/badge/Platforms-Windows-0078D4">
  <br>
  <img alt="Routing" src="https://img.shields.io/badge/Routing-auto__route-blueviolet">
  <img alt="State" src="https://img.shields.io/badge/State-Riverpod-1E3A8A">
  <img alt="Data" src="https://img.shields.io/badge/Data-Drift-0F766E">
  <img alt="Backend" src="https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white">
  <img alt="Sync" src="https://img.shields.io/badge/Sync-PowerSync-4C1D95">
</p>

<h3>Forge living worlds, not just notes.</h3>

<p>Moonforge is a desktop-first Dungeons & Dragons campaign studio built for marathon tables and lore-heavy worlds. Shape campaigns into chapters, adventures, and scenes, track entities across your setting, and keep everything searchable and available offline. It is a focused command center for Dungeon Masters who want clarity, speed, and continuity across every session.</p>


</div>

---

## Table of Contents

- [Highlights](#highlights)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Code Generation](#code-generation)
- [Testing](#testing)
- [Platform Support](#platform-support)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

## ✨ Highlights

* **🧭 Campaign Dashboard:** Search and sort campaigns with a clean card overview.
* **🧱 Structured Outline:** Chapter → adventure → scene tree navigation with ordered numbering.
* **📖 Chapter Workspaces:** Summaries, stats, and linked content panels for adventures and key entities.
* **🗺️ Worldbuilding Entities:** Locations, NPCs, organizations, items, creatures, and encounters as first-class records.
* **🔍 Fast Local Search:** FTS5-backed indexing for offline content lookup.
* **🛰️ Offline-First Sync:** Drift + PowerSync + Supabase with live sync status indicators.

## 📸 Screenshots

<div style="display: flex; flex-wrap: wrap; justify-content: start;">
  <img src="moonforge/assets/images/placeholders/campaign.png" alt="Campaign Overview" width="400" height="225" style="object-fit: cover; border-radius: 8px; margin: 8px;">
</div>

---

## 🛠️ Tech Stack

| Category | Technology | Description |
| :--- | :--- | :--- |
| **Core** | Flutter 3.x / Dart 3.10 | The primary framework and language. |
| **UI** | shadcn_flutter, flutter_acrylic | Modern components and window styling. |
| **State** | Riverpod | `hooks_riverpod` & `flutter_hooks` for state management. |
| **Routing** | Auto Route | Type-safe routing solution. |
| **Data** | Drift (SQLite) | Local persistence and ORM. |
| **Sync** | PowerSync & Supabase | Offline-first sync engine and backend-as-a-service. |
| **Tooling** | build_runner, envied | Code generation and environment variable management. |

## 🏗️ Architecture

| Path | Purpose |
| :--- | :--- |
| `moonforge/lib/main.dart` | Bootstraps windowing, DI, Supabase, and logging. |
| `moonforge/lib/app.dart` | Wires themes, routing, localization, and deep links. |
| `moonforge/lib/core/` | Cross-cutting services, DI, constants, and logging. |
| `moonforge/lib/data/` | Models, stores, and data utilities. |
| `moonforge/lib/features/` | Modular features (Auth, Campaigns, Dashboard, Command). |
| `moonforge/lib/layout/` | App theme and shared layout widgets. |
| `powersync/` | Sync rules and configuration. |
| `supabase/` | Supabase config and generated types. |

---

## 🚀 Getting Started

### Prerequisites
* Flutter 3.x
* Dart 3.10
* Windows (primary development target)

### Installation

Install dependencies and run the app from the `moonforge/` directory:

```bash
cd moonforge
flutter pub get
flutter run
```

## ⚙️ Configuration

- Environment values live in `moonforge/.env` and are loaded by `envied`.
- Do not commit secrets or local credentials.

## 🧰 Code Generation

Run these from `moonforge/` when making model or schema changes:

```bash
dart run build_runner build --delete-conflicting-outputs
dart run tools/generate_database_classes.dart
```

## ✅ Testing

Run tests from `moonforge/`:

```bash
flutter test
```

## 🧭 Platform Support

| Platform | Status |
| --- | --- |
| Windows | Supported |
| Linux | Planned next |
| Web | Planned next |
| Android | Planned later |
| macOS | Not planned |
| iOS | Not planned |

## 🗺️ Roadmap

| Horizon | Focus | Status |
| :--- | :--- | :--- |
| **Now** | Campaign workflows, rich editing, AI creation | In progress |
| **Next** | Linux + Web builds, import/export | Planned |
| **Later** | Mobile companion, automation, advanced search | Exploratory |

## 🤝 Contributing

1. Create a feature branch.
2. Run `flutter pub get` in `moonforge/`.
3. Keep formatting consistent with `flutter format`.
4. Run `flutter test` before opening a PR.
5. Avoid committing secrets from `moonforge/.env`.

## 📄 License

MIT - see `LICENSE`.
