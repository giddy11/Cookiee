# Cookiee

A Flutter recipe app built with GetX: Splash → Onboarding → Auth → Home, with live recipe data
pulled from [dummyjson.com/recipes](https://dummyjson.com/recipes). The Profile tab supports
editing and locally persisting a full profile (photo, name, email, phone, date of birth, gender,
bio) via `shared_preferences`.

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

The profile view uses the same card language as the rest of the app: a large avatar with an
overlaid edit badge up top, then a single grouped card listing each field with an icon, label, and
value, so it reads like a settings/info sheet rather than a form even when you're just viewing it.
Editing is a separate screen reached via "Edit Profile" — keeping view and edit modes visually
distinct avoids accidentally-editable-looking read-only text.

## Screenshots

### Home

![Home screen](screenshots/home_screen.png)

### Profile

![alt text](image.png)