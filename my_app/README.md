# Cookiee

A Flutter recipe app built with GetX: Splash → Onboarding → Auth → Home, with live recipe data
pulled from [dummyjson.com/recipes](https://dummyjson.com/recipes).

## Getting Started

```bash
flutter pub get
flutter run
```

## UI Design Choice

Each recipe is a horizontal list tile (image left, details right) rather than a grid, so a user
can scan name, cuisine, difficulty, cook time, and rating in one glance per row without excessive
scrolling. Difficulty badges are color-coded (green/amber/red) for instant visual triage instead of
reading text. The cyan accent and rounded-pill shapes carry over from the existing Auth screens to
keep one consistent visual language across the whole app.

## Screenshot

### Home

![Home screen](screenshots/home_screen.png)
