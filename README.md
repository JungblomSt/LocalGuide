


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

| Login | Map | Add | List | Detail | Profile |
|---|---|---|---|---|---|
|<img width="200" height="400" alt="login" src="https://github.com/user-attachments/assets/a5ee5f82-c441-4741-8d17-4ebb4fab5448" /> |<img width="200" height="400" alt="homeView" src="https://github.com/user-attachments/assets/3f792eda-e08f-4885-8738-40906199f422" />|<img width="200" height="400" alt="addGuide" src="https://github.com/user-attachments/assets/9f76faf3-2500-416f-80a1-f1ae860a262f" />|<img width="200" height="400" alt="guideList" src="https://github.com/user-attachments/assets/2379ad4f-bee6-4453-b968-5a7f9dbb3d31" />|<img width="200" height="400" alt="detailView" src="https://github.com/user-attachments/assets/f7d18e8b-6dc0-4d64-904e-7283e1e621d8" />|<img width="200" height="400" alt="profile" src="https://github.com/user-attachments/assets/db275c4f-3f07-4feb-a0bf-71489f1f49c2" />|









