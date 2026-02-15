# Notifications Feature

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![CI Status](https://github.com/madabank/madabank-ios/actions/workflows/ci.yml/badge.svg)
![CD Status](https://github.com/madabank/madabank-ios/actions/workflows/cd.yml/badge.svg)
![Language](https://img.shields.io/badge/language-Swift-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)


## Overview
The **Notifications** module manages the display and handling of in-app notifications and push notification settings.

## Features
- List of recent notifications
- Notification settings and preferences
- Mark as read/unread functionality

## Architecture
This module follows the **MVVM-C** (Model-View-ViewModel-Coordinator) pattern.

## Dependencies
- `Shared/Core`
- `Shared/CommonUI`
- `Shared/Domain`

## Installation
Include this module in your `Project.swift`:
```swift
.project(target: "NotificationsInitialiser", path: .relativeToRoot("Modules/Features/Notifications"))
```
