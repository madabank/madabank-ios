# Madabank iOS

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![CI Status](https://github.com/madabank/madabank-ios/actions/workflows/ci.yml/badge.svg)
![CD Status](https://github.com/madabank/madabank-ios/actions/workflows/cd.yml/badge.svg)
![Language](https://img.shields.io/badge/language-Swift-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Architecture](https://img.shields.io/badge/Architecture-Modular%20MVVM--C-green.svg)

The iOS client for **Madabank**, a modern, enterprise-grade banking application built with **Swift** and a **Modular Architecture**. This project demonstrates scalable iOS development practices, including feature modularization, dependency injection, and automated CI/CD pipelines.

---

## 📱 Features

- **Secure Authentication**: Biometric login and secure token management.
- **Dashboard**: Real-time overview of accounts and recent activities.
- **Transactions**: Detailed transaction history with filtering and search.
- **Cards Management**: View and manage physical/virtual cards (freeze, unfreeze, limits).
- **Profile**: User settings and customization.
- **Dark Mode Support**: Fully adaptive UI for light and dark themes.

## 🏗 Architecture & Tech Stack

This project is built using a **Modular Architecture** to ensure scalability, testability, and separation of concerns.

### Key Technologies
- **UIKit & SwiftUI**: Hybrid approach using the best of both worlds.
- **Combine**: Reactive programming for data binding and asynchronous events.
- **SnapKit**: DSL for robust auto-layout code.
- **Tuist**: Project generation and dependency graph management.
- **Fastlane**: Automated building, testing, and deployment.
- **Swinject** (or similar DI pattern): Dependency Injection container.

### Module Structure
The app is divided into isolated modules:
- **App**: The main application target, wiring everything together.
- **Features**: Standalone modules containing UI and logic for specific user flows (e.g., `Auth`, `Home`, `Accounts`).
- **Shared**: Core components used across the app:
    - `Core`: Extensions, utilities, and base classes.
    - `CommonUI`: Design system, reusable UI components, and resources.
    - `data`: Repositories and data sources.
    - `Domain`: Enterprise business rules and use cases.
    - `Networking`: API client and network layer.

## 🚀 Getting Started

### Prerequisites
- Xcode 15+
- Ruby 3.x (managed via Bundler)
- [Mise](https://mise.jdx.dev/) (optional, but recommended for environment management)

### Setup & Installation

To ensure a consistent environment, use the provided setup script. This handles submodules, Ruby gems, and project generation.

```bash
# 1. Clone the repository
git clone https://github.com/your-repo/madabank-ios.git
cd madabank-ios

# 2. Run the setup script
./setup.sh
```

After the script completes, open the workspace:
`Madabank/Madabank.xcworkspace`

> **Note:** If you switch branches or pull changes, run `./setup.sh` again to sync dependencies and regenerate the project.

## 🛠 Development Workflow

### Dependency Management
- **Tuist**: Manages Xcode project structure. Edit `Tuist/Project.swift` to add modules or dependencies.
- **Bundler**: Manages Ruby tools like Fastlane.

To add a new dependency:
1. Update `Tuist/Project.swift` or `Tuist/Package.swift`.
2. Run `./setup.sh` to regenerate the project.

### Code Signing
We use **Fastlane Match** to simplify code signing across the team.
```bash
# Sync certificates (read-only)
bundle exec fastlane sync_certs
```

## 🔄 CI/CD Pipeline

Continuous Integration and Deployment are handled via **GitHub Actions** and **Fastlane**.

### Workflows
- **PR Checks**: Runs linting (`SwiftLint`) and Unit Tests on every Pull Request.
- **TestFlight Deployment**: Automatically builds and uploads to TestFlight on merge to `main` (or manually via dispatch).

### Fastlane Lanes
- `fastlane ci`: Runs linting, tests, and build checks.
- `fastlane beta`: Increments build number, builds the IPA, and uploads to TestFlight.
- `fastlane sync_certs`: Fetches valid certificates/profiles.

## 📂 Project Structure

```
Madabank/
├── Madabank/          # Main App Target
├── Modules/           # Modular Components
│   ├── Features/      # Feature Modules (Auth, Home, etc.)
│   └── Shared/        # Shared Infrastructure (Core, UI, Networking)
├── Tuist/             # Tuist Configuration
├── fastlane/          # Automation Scripts
└── setup.sh           # Setup Script
```

## 🔮 Future Improvements
- [ ] UI Tests and Snapshot Testing
- [ ] Accessibility (Dynamic Type, VoiceOver)
- [ ] Localization (Multi-language support)
- [ ] WatchOS Extension

---

Built with ❤️ by [Your Name]
