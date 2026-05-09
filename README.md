# 🎱 Chalk It Up

A minimalist 9-Ball match scorekeeper with AI-powered trash talk generation.

Built as a portfolio project to demonstrate Flutter/Dart UI development, state management, widget testing, and Claude API integration.

---

## 🛠 Tech Stack

- **Framework:** Flutter 3.41.9
- **Language:** Dart
- **AI:** Anthropic Claude API (claude-sonnet-4-5)
- **Testing:** Flutter Widget Tests

---

## ✨ Features

- Enter player names and race length before match starts
- Tap player panel to score a rack
- Long press to undo last point
- Track innings with + Inning button
- Track who broke
- Winner banner with AI trash talk generator
- New Match button to reset

---

## 🚀 Getting Started

```bash
flutter pub get
flutter run
```

Add your Anthropic API key in `lib/screens/match_screen.dart`:
```dart
'x-api-key': 'your-api-key-here',
```

> ⚠️ Note: In production, API keys should never be hardcoded. This would be proxied through a backend service.

---

## 🧪 Testing

```bash
flutter test
```

12 widget tests covering:
- Setup screen validation
- Match screen interactions
- Post-match locked state behavior

---

## 🎱 Design Decisions

- **9-Ball only** — keeps the app focused and clean
- **No persistence** — casual play, no accounts needed
- **Intentionally minimal** — this is a scorekeeper, not a coaching tool
- **Separate from company work** — distinct from Shell App projects

---

## 🤖 AI-Assisted Development

See [AI-NOTES.md](./AI-NOTES.md) for a transparent log of how AI tooling was used in this project.