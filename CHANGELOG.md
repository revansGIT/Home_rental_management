# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- **Hive Database:** Integrated `hive` and `hive_flutter` for local data persistence.
- **Data Models:** Added robust data models for `Property`, `Unit`, `Tenant`, `Payment`, and `Activity`.
- **Feature-Based Architecture:** Restructured the `lib/` directory into a scalable feature-first approach (`lib/features/`).
- **Routing:** Implemented `go_router` for structured, deep-linkable navigation.
- **State Management:** Added domain-specific providers (`PropertyProvider`, `TenantProvider`, `FinanceProvider`, `ActivityProvider`).

### Changed
- **Localization Path:** Moved `.arb` localization files from `lib/l10n/` to `lib/core/localization/`.
- **Merge Resolution:** Successfully resolved git merge conflicts between UI improvements and backend structural changes, favoring the remote tracking branch structure.

### Removed
- **Dark Mode:** Completely removed dark mode support (including configurations and UI toggles) to maintain a consistent light theme experience, as the dark theme was broken.
