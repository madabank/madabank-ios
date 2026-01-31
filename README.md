# Madabank iOS

The iOS client for Madabank, a modern banking application built with Swift and modular architecture.

## 🏗 Architecture

This project follows a modular architecture using Tuist for project generation.

### Module Structure
- **App**: Main application target
- **Features**: Standalone feature modules (Auth, Home, Accounts, etc.)
- **Shared**: Core components used across features (Core, Networking, Domain, Data, CommonUI)

## 🚀 Getting Started

### Prerequisites
- Xcode 15+
- Ruby 3.x (managed via Bundler)
- Tuist (installed automatically by setup script)

### Setup & Run
To ensure a consistent environment, always use the setup script. This handles submodules, Ruby gems (Fastlane), and Tuist generation.

```bash
./setup.sh
```

After the script completes, open the workspace:
`Madabank/Madabank.xcworkspace`

**Note:** If you switch branches or pull changes, run `./setup.sh` again to sync submodules and regenerate the project.

## 🛠 Development

### Dependency Management
- **Tuist**: Manages Xcode project generation and Swift Package Manager dependencies.
- **Bundler**: Manages Ruby dependencies (Fastlane, CocoaPods).

To add a new dependency:
1. Update `Tuist/Package.swift`
2. Run `./setup.sh`

### Code Signing
We use [Fastlane Match](https://docs.fastlane.tools/actions/match/) for code signing.
To sync certificates (read-only):
```bash
bundle exec fastlane sync_certs
```

## 🔄 CI/CD

Continuous Integration is handled via GitHub Actions and Fastlane. The pipeline is configured for **manual triggering**.

### Triggering a Build
1. Go to the **Actions** tab on GitHub.
2. Select **iOS CI**.
3. Click **Run workflow**.

### Fastlane Lanes
- `fastlane ci`: Runs linting, unit tests, and builds the app (used by GitHub Actions).
- `fastlane beta`: Deploys to TestFlight (increments build number, builds, uploads).
- `fastlane sync_certs`: Fetches distribution certificates and profiles.

## 📂 Project Structure

```
Madabank/
├── Madabank/          # App source code
├── Modules/           # Modular components
│   ├── Features/      # Feature modules (UI flows)
│   └── Shared/        # Shared logic & core infrastructure
├── Tuist/             # Project generation configuration
├── fastlane/          # Fastlane configuration
└── Gemfile            # Ruby dependencies
```
