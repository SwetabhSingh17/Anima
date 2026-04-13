<p align="center">
  <img src="https://img.icons8.com/fluency/96/calendar.png" width="80" alt="Anima Icon"/>
</p>

<h1 align="center">Anima</h1>
<p align="center">
  <em>A beautifully crafted, native calendar app for the Apple ecosystem.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.0-orange?logo=swift&logoColor=white" alt="Swift 5.0"/>
  <img src="https://img.shields.io/badge/SwiftUI-iOS%2026%20|%20macOS%2026%20|%20visionOS-blue?logo=apple&logoColor=white" alt="Platforms"/>
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License"/>
  <img src="https://img.shields.io/badge/Version-1.0.0-cyan" alt="Version"/>
</p>

---

## ✨ Features

- **iOS 26 Liquid Glass UI** — Glassmorphic cards with neon-glow borders `(.ios26Glass)` for a futuristic, translucent aesthetic.
- **Dynamic Island Integration** — Expandable Dynamic Island pill showing the next upcoming event with animated waveform bars.
- **Interactive Notch View** — macOS/iPad notch-style widget for at-a-glance event info, expanding on tap.
- **Animated Background** — Floating, breathing neon orbs (cyan, magenta, deep blue) with continuous parallax animation.
- **Multi-Platform Layout** — Adaptive layouts for iPhone (tab bar), iPad (3-panel sidebar), and macOS (icon rail + sidebar + detail).
- **Week Strip Navigation** — Horizontal scrollable week strip with day-selection, spring animations, and haptic feedback.
- **Month Grid View** — Full calendar month grid with gradient-highlighted selected day and tap haptics.
- **Schedule List** — Event cards with colored icon circles, avatar stacks, and press-to-scale micro-interactions.
- **Search** — Integrated search tab with glass-styled search field.
- **EventKit Integration** — Native calendar sync via `EventKit`, automatically pulling events from all device-linked accounts (Google Calendar, Outlook, iCloud).
- **Widget Extension** — `AnimaWidget` for iOS home screen with glassmorphic event card and dark gradient background.

---

## 🏗️ Architecture

```
Anima/
├── AnimaApp.swift                    # App entry point
├── ContentView.swift                 # Root view — tab routing, iPhone/iPad/Mac layouts
├── Models/
│   └── EventManager.swift            # EventKit integration, calendar sync
├── Views/
│   ├── Calendar/
│   │   ├── MonthView.swift           # Month grid calendar
│   │   ├── WeekStripView.swift       # Horizontal week strip
│   │   └── ScheduleListView.swift    # Event list + EventCard component
│   └── Components/
│       ├── AnimatedBackgroundView.swift  # Floating neon orb background
│       ├── DynamicIslandView.swift       # Dynamic Island pill overlay
│       ├── InteractiveNotchView.swift    # macOS/iPad notch widget
│       └── GlassModifier.swift          # .ios26Glass() ViewModifier
└── AnimaWidget/
    └── AnimaWidget.swift             # Home screen widget extension
```

---

## 📱 Platform Support

| Platform  | Min Deployment | Layout               |
|-----------|----------------|----------------------|
| iOS       | 26.2           | Tab Bar + FAB        |
| iPadOS    | 26.2           | 3-Panel Sidebar      |
| macOS     | 26.2           | Icon Rail + Sidebar  |
| visionOS  | 26.2           | Adaptive             |

---

## 🚀 Getting Started

### Prerequisites

- **Xcode 26.3** or later
- **macOS 26.2** or later
- Apple Developer account (for device testing & EventKit entitlements)

### Build & Run

```bash
# Clone the repository
git clone https://github.com/SwetabhSingh17/Anima.git
cd Anima

# Open in Xcode
open Anima.xcodeproj
```

1. Select a target device (iPhone, iPad, Mac, or visionOS Simulator).
2. Press `⌘R` to build and run.
3. Grant Calendar access when prompted to enable EventKit sync.

---

## 🔑 Permissions

| Permission       | Purpose                                           |
|------------------|---------------------------------------------------|
| Calendar (Full)  | Read events from all linked calendar accounts     |

---

## 📦 Dependencies

**Zero external dependencies** — Anima is built entirely with Apple's first-party frameworks:

- `SwiftUI`
- `EventKit`
- `WidgetKit`

---

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Swetabh Singh**  
[GitHub](https://github.com/swetabhsingh) · Built with ❤️ using SwiftUI

