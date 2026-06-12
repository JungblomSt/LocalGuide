<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-12 at 11 17 32" src="https://github.com/user-attachments/assets/122d4260-c2d3-44ef-b551-11e4f1e77075" />


# LocalGuide

An iOS app that lets users discover and share guided tours of places near them. Browse tours on a map or list, view ratings, leave reviews, save favorites, and create your own guides with images and audio.

## Features

- 🗺️ Browse guides on a map of Sweden with pin annotations
- 📍 List view sorted by distance from your current location (or a hardcoded city for development)
- 🔍 Search and filter guides by title, city, description, or category
- ➕ Create your own guides with photos (from camera or library) and audio
- ⭐ Rate guides 1–5 stars and leave comments
- ❤️ Save guides as favorites to your profile
- 🔐 Sign up / log in with email and password (Firebase Auth)
- 👤 Edit your profile (display name, bio)

## Tech stack

- **iOS 17+ / SwiftUI** — UI framework (`@Observable`, `@State`, `NavigationStack`)
- **MapKit** — interactive maps + markers
- **Core Location** — user location tracking
- **AVFoundation** — audio playback for guide narration
- **Firebase**
  - Authentication (email/password)
  - Firestore (guides, reviews, user profiles)
  - Storage (images and audio files)
                                            
- **Architecture** — MVVM (Models, ViewModels, Views, Services)
                                            
                                            LocalGuide/
                                            ├── LocalGuideApp.swift
                                            ├── ContentView.swift
                                            ├── Models/
                                            ├── Services/
                                            ├── Managers/
                                            ├── Auth/
                                            │   ├── Viewmodels/
                                            │   └── Views/
                                            ├── Guides/
                                            │   ├── Viewmodels/
                                            │   └── Views/
                                            ├── Profile/
                                            │   ├── Viewmodels/
                                            │   └── Views/                  
                                            └── Assets.xcassets


## Setup

### Prerequisites

- macOS 14+
- Xcode 16+
- An Apple ID (free Personal Team is enough for running on your device)

### Steps

1. Clone the repo:
   ```bash
   git clone https://github.com/JungblomSt/LocalGuide.git
   cd LocalGuide
attachments/assets/fb198b57-7ad1-4255-a1d7-c01ce549113d" />
