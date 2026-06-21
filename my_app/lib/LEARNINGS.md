# Cookiee App — Code Learnings

A beginner-friendly walkthrough of every file in this Flutter project.

---

## `lib/splash_screen.dart`

### What this file does

This file creates the **Splash Screen** — the first screen a user sees when they open the app. It shows a logo and the app name "Cookiee" for 3 seconds, then automatically sends the user to the Login screen.

---

### How it works — step by step

#### 1. The Timer (Auto-navigation)

```dart
Timer(const Duration(seconds: 3), () {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
});
```

- `Timer` waits for **3 seconds**, then runs the code inside the `{}` block.
- `Navigator.of(context).pushReplacement(...)` replaces the current screen (splash) with the Login screen.
- `pushReplacement` means the user **cannot press the back button** to return to the splash screen — which is the correct behaviour for a splash screen.

#### 2. Two Classes in one file

The file defines **two widget classes**:

| Class | Type | Purpose |
|---|---|---|
| `SplashScreen` | `StatefulWidget` | The full screen — manages the timer |
| `_SplashLogo` | `StatelessWidget` | Just the logo image — no state needed |

The underscore `_` in `_SplashLogo` and `_SplashScreenState` means they are **private** — only usable inside this file.

#### 3. `StatefulWidget` vs `StatelessWidget`

- `SplashScreen` is a **StatefulWidget** because something *happens over time* (the 3-second timer).
- `_SplashLogo` is a **StatelessWidget** because it just displays an image — nothing changes.

A `StatefulWidget` always comes in a pair:
- The widget class itself (`SplashScreen`) — describes what the widget *is*.
- A state class (`_SplashScreenState`) — holds the logic and data.

#### 4. `initState()` — where the timer starts

```dart
@override
void initState() {
  super.initState();
  Timer(const Duration(seconds: 3), () { ... });
}
```

`initState()` is a **lifecycle method** — Flutter calls it automatically when the screen is first created. This is the right place to start a timer, fetch data, or run any one-time setup code.

`super.initState()` must always be called first — it lets Flutter do its own internal setup before yours.

#### 5. The UI Layout

```dart
Scaffold(
  backgroundColor: Colors.white,
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SplashLogo(),
        SizedBox(height: 20),
        Text('Cookiee', ...),
      ],
    ),
  ),
)
```

- `Scaffold` — the base frame of every screen (background, app bar, body, etc.).
- `Center` — centres its child both horizontally and vertically.
- `Column` — stacks widgets **vertically** (top to bottom).
- `SizedBox(height: 20)` — adds 20 pixels of empty space between the logo and the text.
- `mainAxisAlignment: MainAxisAlignment.center` — tells the column to centre its children vertically.

#### 6. Loading the Logo Image

```dart
Image.asset(
  'lib/assets/images/splash.png',
  width: 120,
  height: 120,
  fit: BoxFit.contain,
)
```

- `Image.asset(...)` loads an image that is bundled **inside** the app (not from the internet).
- `BoxFit.contain` scales the image to fit within 120×120 without cropping it.

---

### Concepts to master to fully understand this file

Work through these in order — each one builds on the previous.

| # | Concept | Why it matters here |
|---|---|---|
| 1 | **Dart basics** — variables, functions, classes, `const`, access modifiers (`_`) | Everything in Flutter is written in Dart |
| 2 | **Widgets** — what they are, how they compose | Every visual element (`Text`, `Column`, `Scaffold`) is a widget |
| 3 | **StatelessWidget vs StatefulWidget** | You need to know which to use and why |
| 4 | **Widget lifecycle** — `initState`, `dispose`, `build` | Knowing *when* Flutter calls each method prevents bugs |
| 5 | **`dart:async` — `Timer`, `Future`** | Used here to delay navigation by 3 seconds |
| 6 | **Flutter Navigation** — `Navigator`, `pushReplacement`, `push`, `pop` | Controls how screens transition |
| 7 | **Layout widgets** — `Scaffold`, `Column`, `Row`, `Center`, `SizedBox` | You will use these on almost every screen |
| 8 | **Assets in Flutter** — `pubspec.yaml` asset registration, `Image.asset` | Required to display any local image |
| 9 | **`const` keyword in Flutter** | Tells Flutter the widget never changes — improves performance |
| 10 | **Private vs public in Dart** — the `_` prefix | Controls visibility; important for clean code |

---

### Recommended learning path (beginner)

1. **Dart language tour** — start at the official Dart docs (`dart.dev/guides/language/language-tour`)
2. **Flutter widget catalogue** — `flutter.dev/docs/development/ui/widgets`
3. **Flutter layout guide** — understand `Column`, `Row`, `Stack`
4. **StatefulWidget codelab** — on `flutter.dev`
5. **Navigation & routing** — Flutter cookbook on `flutter.dev`

---

---

## `lib/screens/login_screen.dart`

### What this file does

This is the **Login Screen** — the screen where a returning user types their email and password to get into the app. If the fields are empty it shows an error message. If they are filled in, it navigates to the Main screen.

---

### How it works — step by step

#### 1. `TextEditingController` — reading what the user typed

```dart
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
```

A `TextEditingController` is a special object that stays connected to a text field. Whenever the user types something, the controller knows about it. You can then read the value with `.text`.

Think of it like a live wire between the text box on screen and your Dart code.

#### 2. `dispose()` — cleaning up controllers

```dart
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}
```

`dispose()` is a lifecycle method called when the screen is **permanently removed** from the app. Controllers use memory, so you must call `.dispose()` on each one here to free that memory. Forgetting this causes **memory leaks** — the app slowly eats up RAM over time.

Rule of thumb: **every controller you create must be disposed**.

#### 3. `_onLogin()` — the login logic

```dart
void _onLogin() {
  if (_emailController.text.trim().isEmpty ||
      _passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(...);
    return;
  }
  Navigator.of(context).pushReplacement(...);
}
```

- `.text` — reads the current text inside the field.
- `.trim()` — removes any accidental spaces at the start or end (so a field with only spaces is still treated as empty).
- `.isEmpty` — returns `true` if the string has no characters.
- `return` — exits the function early if validation fails. Nothing after it runs.
- `ScaffoldMessenger.of(context).showSnackBar(...)` — shows a small popup bar at the bottom of the screen with an error message.
- If validation passes, `pushReplacement` navigates to `MainScreen`, passing the email as data.

#### 4. Passing data between screens

```dart
MainScreen(
  name: '',
  email: _emailController.text.trim(),
)
```

When navigating to `MainScreen`, you hand it the `email` value directly through its **constructor**. This is how screens share data in Flutter — you pass values when you create the widget, just like arguments to a function.

#### 5. The Layout structure

```
Scaffold
└── SafeArea
    └── Column
        ├── Expanded → SingleChildScrollView → Column (all the form fields)
        └── Padding → ElevatedButton (the Login button, always at the bottom)
```

- `SafeArea` — keeps content away from the phone's notch, status bar, and home indicator.
- `Expanded` — makes the scrollable area take up all the space above the button.
- `SingleChildScrollView` — makes the form content scrollable so the keyboard doesn't cover the fields on small screens.
- `ElevatedButton` outside the `Expanded` — pins the button to the bottom of the screen at all times.

#### 6. The three custom helper classes

| Class | Type | Purpose |
|---|---|---|
| `_LoginScreenState` | State | Holds controllers, validation, and navigation logic |
| `_FieldLabel` | `StatelessWidget` | Reusable label widget above each text field |
| `_RoundedTextField` | `StatelessWidget` | Reusable styled text field with rounded borders |

Both `_FieldLabel` and `_RoundedTextField` are **reusable components** — defined once and used multiple times in the form. This avoids repeating the same styling code for every field.

#### 6a. Why removing `label` from `_FieldLabel` causes an error

Here is the full `_FieldLabel` class:

```dart
class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,           // <-- label is used HERE
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black54,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
```

There are **two things working together** that make this break when you remove `label`:

**Thing 1 — `final String label;`**

This declares a field (a piece of data) that the widget owns. The type is `String`, meaning it must always hold a text value. It is `final`, which means once it is set it can never be changed.

**Thing 2 — `required this.label` in the constructor**

```dart
const _FieldLabel({required this.label});
```

`required` tells Dart: *"whoever creates a `_FieldLabel` widget MUST pass a `label` value — there is no default."*

So every time `_FieldLabel` is used in the form, it looks like this:

```dart
_FieldLabel(label: 'PHONE OR EMAIL')
_FieldLabel(label: 'PASSWORD')
```

**What happens when you remove `label` from `Text(...)`:**

The `Text` widget needs a `String` to display. If you write `Text()` with nothing inside, Dart immediately gives a compile error because `Text` also has a `required` first argument. More importantly, `label` is the only data this widget has — removing it from `Text(label, ...)` means the widget has no text to show, which Dart won't allow.

**The mental model:**

Think of `_FieldLabel` like a stamp machine. The `label` is the text you insert into the machine. The machine (`build` method) takes that text and prints it on screen in a specific style. If you don't give the machine any text, it cannot stamp anything — so Dart stops you before the app even runs.

**`letterSpacing` and `fontWeight` — what they do:**

- `fontSize: 11` — small text, since these are just field labels, not headings.
- `color: Colors.black54` — 54% opaque black, which gives a grey colour. Flutter uses opacity suffixes: `black12`, `black26`, `black45`, `black54`, `black87` — the number is the opacity percentage.
- `letterSpacing: 0.8` — adds a tiny gap between each letter. Used here because the labels are ALL CAPS (`'PHONE OR EMAIL'`), and spaced capitals are easier to read.
- `fontWeight: FontWeight.w500` — medium weight (between normal `w400` and bold `w700`).

#### 7. `_RoundedTextField` — a reusable text field (in detail)

Here is the full class:

```dart
class _RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  const _RoundedTextField({
    required this.controller,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF00BCD4), width: 1.5),
        ),
      ),
    );
  }
}
```

---

**Part A — The three fields (the widget's data)**

```dart
final TextEditingController controller;
final String hint;
final bool obscure;
```

Every `_RoundedTextField` you create carries these three pieces of data:

| Field | Type | What it stores |
|---|---|---|
| `controller` | `TextEditingController` | The object that reads what the user typed |
| `hint` | `String` | The grey placeholder text shown before the user types |
| `obscure` | `bool` | Whether to hide the text as dots (`●●●●`) — used for passwords |

---

**Part B — The constructor**

```dart
const _RoundedTextField({
  required this.controller,
  required this.hint,
  this.obscure = false,
});
```

- `required this.controller` — the caller **must** pass a controller. No default exists.
- `required this.hint` — the caller **must** pass hint text. No default exists.
- `this.obscure = false` — **optional**. If you don't mention it, it defaults to `false` (text is visible). Only the password fields pass `obscure: true`.

So when you write `_RoundedTextField(controller: _emailController, hint: 'Enter your email')`, Dart automatically assigns those values to the three fields above.

---

**Part C — `TextField` and its properties**

```dart
TextField(
  controller: controller,
  obscureText: obscure,
  style: const TextStyle(fontSize: 14),
  decoration: InputDecoration(...),
)
```

- `controller: controller` — connects this text field to the controller so your code can read what was typed. Without this, `.text` would always be empty.
- `obscureText: obscure` — when `true`, every character the user types is shown as `●`. This is how password fields work.
- `style: TextStyle(fontSize: 14)` — the style of the **text the user types** (not the hint). Sets font size to 14.
- `decoration: InputDecoration(...)` — controls everything about the visual appearance of the field: hint, padding, borders.

---

**Part D — `InputDecoration` broken down piece by piece**

**`hintText` and `hintStyle`:**
```dart
hintText: hint,
hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
```
- `hintText` — the placeholder text shown in grey when the field is empty (e.g. "Enter your email"). It disappears the moment the user starts typing.
- `hintStyle` — the style of that placeholder. `Colors.black38` means 38% opaque black — a light grey. Lower number = more transparent.

**`contentPadding`:**
```dart
contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
```
- Controls the **space between the field border and the text inside it**.
- `horizontal: 20` — 20 pixels of padding on the left and right, so the text doesn't start right at the edge.
- `vertical: 14` — 14 pixels of padding on the top and bottom, which controls the **height** of the field.

**The three border states:**

This is one of the most important parts. Flutter lets you define a different border for each state the text field can be in:

```dart
border: OutlineInputBorder(
  borderRadius: BorderRadius.circular(30),
  borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
),
enabledBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(30),
  borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
),
focusedBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(30),
  borderSide: const BorderSide(color: Color(0xFF00BCD4), width: 1.5),
),
```

| Border | When it shows | Colour here |
|---|---|---|
| `border` | Fallback default (rarely shown directly) | Light grey `0xFFCCCCCC` |
| `enabledBorder` | Field is visible but the user has NOT tapped it | Light grey `0xFFCCCCCC` |
| `focusedBorder` | User has tapped the field and is typing | Cyan `0xFF00BCD4`, slightly thicker (`width: 1.5`) |

You need both `border` and `enabledBorder` because Flutter picks `enabledBorder` over `border` when the field is enabled — if you only set `border`, the enabled state would fall back to Flutter's default blue border.

**`BorderRadius.circular(30)`:**

`30` is a large radius, which makes the corners very rounded — creating the "pill" shape. A value of `0` would give sharp square corners. The value `30` was chosen to match the Login button's shape, keeping the design consistent.

**`BorderSide`:**
```dart
BorderSide(color: Color(0xFFCCCCCC))
BorderSide(color: Color(0xFF00BCD4), width: 1.5)
```
- `color` — the colour of the border line.
- `width` — the thickness of the border line. Default is `1.0`. The focused border uses `1.5` to make it slightly more prominent when active.

**Colour format — `0xFF______`:**

Flutter colours are written in hex: `0xFF` followed by 6 hex digits (`RRGGBB`):
- `0xFF` — always means fully opaque (100% visible).
- `CCCCCC` — equal parts red, green, blue → grey.
- `00BCD4` — this is the cyan/teal brand colour used throughout the app.

---

**Part E — Why this widget exists at all**

Without `_RoundedTextField`, the email and password fields would each need their own full `TextField` block with all the same `InputDecoration` repeated twice. That's ~20 lines of identical code duplicated. Instead, the styling is written once inside `_RoundedTextField`, and each field just passes its own `controller` and `hint`:

```dart
// Email field — 1 line
_RoundedTextField(controller: _emailController, hint: 'Enter your phone or email')

// Password field — 2 lines
_RoundedTextField(controller: _passwordController, hint: 'Enter your password', obscure: true)
```

This is the **DRY principle** — Don't Repeat Yourself. It is one of the most fundamental ideas in programming.

#### 8. `GestureDetector` — making any widget tappable

```dart
GestureDetector(
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  },
  child: const Text('Register', ...),
)
```

`GestureDetector` wraps any widget and detects touch events. Here it makes the "Register" text act like a link. `push` (not `pushReplacement`) is used so the user *can* press the back button to return to Login from Register.

#### 9. `Image.network` with error fallback

```dart
Image.network(
  'https://...',
  errorBuilder: (ctx, err, st) => Container(
    child: const Icon(Icons.restaurant, ...),
  ),
)
```

`Image.network` loads an image from the internet. `errorBuilder` provides a fallback widget shown if the image fails to load (e.g. no internet). This is good defensive UI.

---

### Concepts to master for this file

| # | Concept | Why it matters here |
|---|---|---|
| 1 | **`TextEditingController`** | Reads user input from text fields |
| 2 | **Widget lifecycle — `dispose()`** | Prevents memory leaks from controllers |
| 3 | **Form validation** — `.trim()`, `.isEmpty`, early `return` | Basic input checking before acting |
| 4 | **`ScaffoldMessenger` / `SnackBar`** | Showing feedback messages to the user |
| 5 | **Passing data to screens via constructors** | How screens communicate in Flutter |
| 6 | **`SafeArea`** | Keeps UI away from system UI (notch, home bar) |
| 7 | **`Expanded` + `SingleChildScrollView`** | Makes scrollable forms that don't get covered by the keyboard |
| 8 | **Reusable widgets** — extracting `StatelessWidget` classes | Avoids repeating styling code |
| 9 | **Default parameters** — `this.obscure = false` | Optional constructor arguments with fallback values |
| 10 | **`GestureDetector`** | Making any widget respond to taps |
| 11 | **`push` vs `pushReplacement`** | Whether the user can navigate back or not |
| 12 | **`Image.network` + `errorBuilder`** | Loading images from URLs with a fallback |

---

## `lib/screens/register_screen.dart`

### What this file does

This is the **Register Screen** — where a new user creates an account by filling in their name, email, password, and birthdate. It validates that all fields are filled and that the two password fields match before navigating to the Main screen.

---

### How it works — step by step

#### 1. Four controllers + one DateTime variable

```dart
final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();
DateTime? _selectedDate;
```

Previously the birthdate was a plain text field with a `TextEditingController`. It has been replaced with a `DateTime?` variable — a proper date value instead of raw text.

- `DateTime` is a Dart built-in type that stores a full date and time (year, month, day, hour, etc.).
- The `?` after `DateTime` means it is **nullable** — it can either hold a date or be `null` (nothing selected yet). When the screen first opens, `_selectedDate` is `null` because the user hasn't picked a date yet.
- Because there is no controller for birthdate anymore, `dispose()` only disposes four controllers — not five.

#### 2. `_pickDate()` — opening the system date picker

```dart
Future<void> _pickDate() async {
  final now = DateTime.now();
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime(now.year - 18, now.month, now.day),
    firstDate: DateTime(1900),
    lastDate: now,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00BCD4),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() => _selectedDate = picked);
  }
}
```

This is the most technically advanced piece of the register screen. Break it down piece by piece:

**`Future<void>` and `async`/`await`:**

`showDatePicker` opens a popup calendar. The user might take several seconds to pick a date, so the app cannot just freeze and wait — it needs to keep running. This is handled with `async`/`await`:

- `async` marks the function as asynchronous — it can pause mid-way and resume later.
- `await` pauses *only this function* (not the whole app) until `showDatePicker` finishes.
- `Future<void>` means the function will eventually finish but returns no useful value when it does.

Think of it like placing an order at a restaurant. You (`_pickDate`) place the order (`showDatePicker`), then sit and wait (`await`). The kitchen (Flutter) keeps serving other tables (the rest of the app). When your order is ready, you continue.

**`showDatePicker` arguments:**

| Argument | Value | What it does |
|---|---|---|
| `context` | current context | Tells Flutter which screen to show the picker on top of |
| `initialDate` | `now.year - 18` | The calendar opens at 18 years ago — a sensible default for age |
| `firstDate` | `DateTime(1900)` | The earliest date the user can scroll back to |
| `lastDate` | `now` | The user cannot pick a future date |

**`builder` — theming the date picker:**

```dart
builder: (context, child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF00BCD4),   // selected date colour
        onPrimary: Colors.white,       // text ON the selected date
        onSurface: Colors.black,       // all other text
      ),
    ),
    child: child!,
  );
},
```

By default, the date picker uses the app's theme colour (often purple/blue). The `builder` wraps it in a custom `Theme` to make the selected date show in cyan (`0xFF00BCD4`) — matching the rest of the app.

- `Theme.of(context).copyWith(...)` — takes the existing theme and changes only the parts you specify. Everything else stays the same.
- `child!` — the `!` is the **null assertion operator**. It tells Dart: "I know `child` is not null here, trust me." Flutter always passes a valid child to this builder, so it is safe.

**Saving the picked date:**

```dart
if (picked != null) {
  setState(() => _selectedDate = picked);
}
```

- If the user dismisses the picker without choosing (presses back), `picked` is `null` — so nothing changes.
- If a date was chosen, `setState(...)` is called to save it and **rebuild the UI** so the date appears on screen.
- `setState` is how a `StatefulWidget` tells Flutter "my data changed, redraw this widget." Without it, `_selectedDate` would update internally but the screen would not visually change.

---

#### 3. `_onRegister()` — two layers of validation

```dart
void _onRegister() {
  // Layer 1: check all fields are filled
  if (_nameController.text.trim().isEmpty || ... || _selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(...'Please fill in all fields'...);
    return;
  }
  // Layer 2: check passwords match
  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(...'Passwords do not match'...);
    return;
  }
  Navigator.of(context).pushReplacement(...);
}
```

There are **two separate validation checks**, run in order:
1. Are all fields filled in? — notice the birthdate check is now `_selectedDate == null` instead of `.isEmpty`, because it's a `DateTime?` not a `String`.
2. Do the passwords match?

If either check fails, `return` stops the function immediately — the navigation only happens if both checks pass. This is called **guard clause** or **early return** pattern — it's a very clean way to write validation.

#### 4. Passing both `name` and `email` to MainScreen

```dart
MainScreen(
  name: _nameController.text.trim(),
  email: _emailController.text.trim(),
)
```

Unlike the Login screen (which passed an empty `name: ''`), Register passes the actual name the user typed. `MainScreen` can then use it to greet the user personally.

#### 4. Same layout pattern as Login

The layout is identical in structure to `LoginScreen`:

```
Scaffold → SafeArea → Column
  ├── Expanded → SingleChildScrollView → form fields
  └── ElevatedButton pinned at bottom
```

This consistency is intentional — once you understand the Login layout, Register requires no new layout knowledge.

#### 5. The birthdate field — a custom tappable container

The birthdate is no longer a `_RoundedTextField`. Instead it is a `GestureDetector` wrapping a styled `Container`:

```dart
GestureDetector(
  onTap: _pickDate,
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(
      border: Border.all(
        color: _selectedDate != null ? const Color(0xFF00BCD4) : const Color(0xFFCCCCCC),
        width: _selectedDate != null ? 1.5 : 1,
      ),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            _selectedDate != null
                ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                : 'Select your birth date',
            style: TextStyle(
              fontSize: 14,
              color: _selectedDate != null ? Colors.black87 : Colors.black38,
            ),
          ),
        ),
        const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black38),
      ],
    ),
  ),
),
```

**Why a `Container` and not a `TextField`?**

A `TextField` is for typing. The birthdate field doesn't let the user type — it opens a calendar popup. So it uses a plain `Container` styled to *look* like the other fields, with a `GestureDetector` to detect the tap.

**The border changes colour based on whether a date is selected:**

```dart
color: _selectedDate != null ? const Color(0xFF00BCD4) : const Color(0xFFCCCCCC),
width: _selectedDate != null ? 1.5 : 1,
```

This uses the **ternary operator** — a compact if/else written in one line:
```
condition ? value_if_true : value_if_false
```

So: if a date has been picked → cyan border, width 1.5. If not → grey border, width 1. This gives the same "active" visual feedback that `focusedBorder` gives the text fields.

**Displaying the date as `DD/MM/YYYY`:**

```dart
'${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
```

- `_selectedDate!` — the `!` asserts it's not null (safe here because we're inside `_selectedDate != null` check).
- `.day`, `.month`, `.year` — properties on `DateTime` that give you individual parts of the date.
- `.toString()` — converts the number to a string (e.g. `5` → `"5"`).
- `.padLeft(2, '0')` — if the string is shorter than 2 characters, adds a `'0'` on the left. So `5` becomes `"05"`, but `12` stays `"12"`. This is how you get `05/03/2001` instead of `5/3/2001`.
- The whole thing is wrapped in `${}` inside a string — this is **string interpolation**, Dart's way of embedding a variable or expression directly inside a string.

**The calendar icon:**

```dart
const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black38)
```

`Icons.calendar_today_outlined` is one of Flutter's built-in Material icons. It's placed at the right side of the row using `Row` + `Expanded` (the text expands to fill the space, pushing the icon to the far right).

---

#### 6. `_FieldLabel` and `_RoundedTextField` are duplicated here

Both helper classes (`_FieldLabel` and `_RoundedTextField`) are **copied** into this file identically. In a more advanced app these would be extracted into a shared file (e.g. `lib/widgets/form_widgets.dart`) so they only exist once. This is a refactoring opportunity you can explore later.

---

### What is new in this file vs Login

| Feature | Login | Register |
|---|---|---|
| Number of fields | 2 | 5 |
| Validation checks | 1 (empty check) | 2 (empty + password match) |
| Name passed to MainScreen | Empty string `''` | Actual user name |
| Helper classes | Same `_FieldLabel`, `_RoundedTextField` | Same (duplicated) |

---

### Concepts to master for this file

Most concepts overlap with `login_screen.dart`. The new ones are:

| # | Concept | Why it matters here |
|---|---|---|
| 1 | **Multiple `TextEditingController`s** | One controller per field — you must dispose all of them |
| 2 | **Guard clauses / early return pattern** | Clean validation: check conditions first, act only when all pass |
| 3 | **String equality** — `!=` | Comparing two strings to check if passwords match |
| 4 | **Code duplication vs shared widgets** | Understanding when to extract reusable widgets into a shared file |
| 5 | **Nullable types** — `DateTime?`, `null`, `!` | A variable that may or may not have a value yet |
| 6 | **`async`/`await` and `Future`** | How to wait for something (like a picker) without freezing the app |
| 7 | **`showDatePicker`** | Flutter's built-in calendar popup |
| 8 | **`setState`** | How to tell Flutter to redraw the screen after data changes |
| 9 | **Ternary operator** — `condition ? a : b` | Compact if/else used to swap colour/style based on state |
| 10 | **`DateTime` type** — `.day`, `.month`, `.year` | Working with real date values instead of raw text |
| 11 | **`.padLeft(2, '0')`** | Formatting numbers to always show two digits (e.g. `05`) |
| 12 | **String interpolation** — `'${expression}'` | Embedding values directly inside strings |
| 13 | **`Theme.copyWith`** | Overriding only part of a theme without replacing the whole thing |

---

### Recommended learning path (beginner)

1. **Dart functions** — parameters, `required`, default values, `return`
2. **`TextEditingController`** — Flutter docs on "text fields"
3. **Form validation** — Flutter cookbook: "Build a form with validation"
4. **Flutter `Navigator`** — push, pop, pushReplacement, and passing data
5. **Widget composition** — how to extract repeated UI into its own class

---

---

## `lib/screens/main_screen.dart`

### What this file does

This is the **shell screen** of the app — the container that holds all the main tabs (Home, Cart, Profile, Notifications, Settings). It is not a content screen itself; it just manages which tab is visible and renders the bottom navigation bar.

After login or registration, every user lands here and stays here for the rest of their session.

---

### How it works — step by step

#### 1. Receiving data from the previous screen

```dart
class MainScreen extends StatefulWidget {
  final String name;
  final String email;

  const MainScreen({super.key, required this.name, required this.email});
```

`MainScreen` accepts `name` and `email` from whichever screen navigated to it (Login or Register). These are stored as `final` fields on the widget itself — not in the state class — because they never change while the screen is alive.

#### 2. `_currentIndex` — tracking the active tab

```dart
int _currentIndex = 0;
```

This single integer controls everything. It stores the index of the currently visible tab:

| Value | Tab |
|---|---|
| `0` | Home |
| `1` | Cart |
| `2` | Profile |
| `3` | Notifications |
| `4` | Settings |

When the user taps a nav bar item, `_currentIndex` is updated and Flutter redraws the screen showing the new tab.

#### 3. `late final List<Widget> _tabs` — the list of tab screens

```dart
late final List<Widget> _tabs;

@override
void initState() {
  super.initState();
  _tabs = [
    HomeTab(email: widget.email),
    const CartTab(),
    MyProfilePage(name: widget.name, email: widget.email),
    const NotificationsTab(),
    const SettingsTab(),
  ];
}
```

`_tabs` is a list that holds one widget per tab. The active tab is shown using `_tabs[_currentIndex]` in the body.

**Why `late`?**

`late` means: "this variable will be assigned before it is first used, but not right now at declaration time." It is needed here because the list is built inside `initState()`, not at the top of the class where `_currentIndex` is declared. Without `late`, Dart would complain that `_tabs` has no value yet.

**Why build the list in `initState()` and not in `build()`?**

If you built `_tabs` inside `build()`, Flutter would create brand new instances of `HomeTab`, `CartTab`, etc. every single time the screen redraws (which happens every time you tap a nav item). That would reset each tab's state. By building the list once in `initState()`, the same tab instances are reused every time — so if the user adds something to the cart and switches to Home, the cart still has the item when they switch back.

**`widget.name` and `widget.email`:**

Inside the state class (`_MainScreenState`), you cannot directly access `name` and `email` because they are defined on the widget, not the state. `widget.` is how the state class reaches back to its paired widget to read its data.

#### 4. The `build` method — body + bottom nav bar

```dart
return Scaffold(
  body: _tabs[_currentIndex],
  bottomNavigationBar: Container(...),
);
```

The `body` is simply `_tabs[_currentIndex]` — whichever tab widget is at the current index. Swapping tabs is just swapping this one value.

#### 5. The styled bottom navigation bar

The `BottomNavigationBar` is wrapped in a `Container` + `ClipRRect` to give it rounded top corners and a shadow:

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 16,
        offset: Offset(0, -4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.only(...),
    child: BottomNavigationBar(...),
  ),
)
```

- `BoxDecoration` — adds visual styling to a `Container`: colour, border, shadow, radius.
- `BorderRadius.only(topLeft: ..., topRight: ...)` — rounds only the top two corners, leaving the bottom corners square (they're at the screen edge so it doesn't matter).
- `boxShadow` — adds a shadow above the nav bar to visually lift it off the content.
  - `color: Color(0x1A000000)` — `0x1A` is the opacity in hex. `1A` in hex = `26` in decimal = about 10% opacity. Very subtle shadow.
  - `blurRadius: 16` — how spread out the shadow is. Larger = softer.
  - `offset: Offset(0, -4)` — moves the shadow 4 pixels *upward* (`-4` on the Y axis) so it appears above the bar, not below it.
- `ClipRRect` — clips its child widget into a rounded rectangle shape. The `Container` draws the rounded decoration, and `ClipRRect` enforces that the `BottomNavigationBar` itself doesn't overflow those rounded corners.

**Why both `Container` and `ClipRRect`?**

`Container`'s `borderRadius` only clips the decoration (the background colour and shadow). The `BottomNavigationBar` widget inside it can still visually overflow the corners. `ClipRRect` physically clips all child pixels to the rounded shape.

#### 6. `BottomNavigationBar` properties

```dart
BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  type: BottomNavigationBarType.fixed,
  selectedItemColor: const Color(0xFF00BCD4),
  unselectedItemColor: const Color(0xFF9E9E9E),
  selectedFontSize: 11,
  unselectedFontSize: 11,
  backgroundColor: Colors.white,
  elevation: 0,
  items: const [...],
)
```

| Property | What it does |
|---|---|
| `currentIndex` | Tells the bar which item is currently active |
| `onTap` | Called when user taps an item — updates `_currentIndex` via `setState` |
| `type: fixed` | All items are always visible and equally spaced. The alternative (`shifting`) hides labels on inactive items |
| `selectedItemColor` | Cyan for the active tab icon and label |
| `unselectedItemColor` | Grey (`0xFF9E9E9E`) for inactive tabs |
| `selectedFontSize / unselectedFontSize` | Both set to `11` so the label size doesn't jump when switching tabs |
| `elevation: 0` | Removes the nav bar's own built-in shadow (replaced by the custom `boxShadow` on the `Container`) |

#### 7. Each `BottomNavigationBarItem` — `icon` vs `activeIcon`

```dart
BottomNavigationBarItem(
  icon: Icon(Icons.home_outlined),
  activeIcon: Icon(Icons.home),
  label: 'Home',
),
```

- `icon` — shown when this tab is **not** selected (outlined style = lighter).
- `activeIcon` — shown when this tab **is** selected (filled style = heavier/bolder).

This is a common UI pattern: outlined icons for inactive, filled icons for active. It gives clear visual feedback about which tab you're on without needing colour alone.

---

### Concepts to master for this file

| # | Concept | Why it matters here |
|---|---|---|
| 1 | **`late` keyword** | Declaring a variable that will be assigned later (in `initState`) |
| 2 | **`widget.` accessor** | How the state class reads data from its paired widget |
| 3 | **List indexing** — `_tabs[_currentIndex]` | How the correct tab screen is selected and displayed |
| 4 | **Why `initState` not `build` for tab list** | Prevents tab state from resetting on every redraw |
| 5 | **`BottomNavigationBar`** | Flutter's built-in nav bar widget and its key properties |
| 6 | **`BoxDecoration`** — `borderRadius`, `boxShadow` | Adding visual styling (rounded corners, shadows) to containers |
| 7 | **`ClipRRect`** | Physically clipping child widgets to a rounded shape |
| 8 | **`BoxShadow`** — `blurRadius`, `offset`, hex opacity | How shadows work and how `0x1A` opacity is read |
| 9 | **`Offset`** | An x/y coordinate used for shadow direction |
| 10 | **`icon` vs `activeIcon`** | The outlined/filled icon pattern for navigation feedback |
| 11 | **`BottomNavigationBarType.fixed`** | Why all tabs stay visible vs the `shifting` alternative |


---

## Export and Testing

### Android Internet Permission — `AndroidManifest.xml`

When you run your Flutter app on an Android emulator or physical Android device, Android **blocks all internet access by default**. This is a security feature built into Android — apps must explicitly declare what permissions they need.

Because this app loads an image from the internet (`Image.network(...)`), it will show the grey fallback icon instead of the actual image if this permission is missing.

---

**Where the file is:**

```
my_app/
└── android/
    └── app/
        └── src/
            └── main/
                └── AndroidManifest.xml
```

**What to add:**

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Place it **before the last closing tag** in the file, which is `</manifest>`. The result should look like this:

```xml
<manifest xmlns:android="...">

    <uses-permission android:name="android.permission.INTERNET"/>

    <application
        ...
    </application>

</manifest>
```

---

**Breaking down the line:**

| Part | What it means |
|---|---|
| `<uses-permission` | An XML tag telling Android "this app needs a permission" |
| `android:name=` | The attribute that names which permission |
| `"android.permission.INTERNET"` | The specific permission — allow this app to make network requests |
| `/>` | Self-closing tag (no separate closing tag needed) |

---

**Why Flutter does not do this automatically:**

Flutter generates `AndroidManifest.xml` when you create a project, but it does not assume your app needs the internet. You must opt in. This is intentional — Android follows the **principle of least privilege**: apps should only have access to what they explicitly declare, so a malicious app cannot silently make network calls without the user knowing.

---

**Does iOS need something similar?**

Yes, but differently. iOS does not need a permission entry in `Info.plist` just to use the internet — HTTPS requests work by default. However, if your app loads images over plain `http://` (not `https://`), iOS blocks it unless you add an exception. Since this app uses `https://` (Unsplash), iOS works without any changes.

---

**What is XML?**

`AndroidManifest.xml` is written in **XML** (eXtensible Markup Language) — a format for storing structured data using tags, similar to HTML. Each tag has a name and can have attributes (key-value pairs). Flutter itself uses Dart, but Android's configuration files use XML because that is the Android platform's native format.

---

**Concepts to understand here:**

| # | Concept | Why it matters |
|---|---|---|
| 1 | **`AndroidManifest.xml`** | The central config file for every Android app — declares permissions, app name, entry point, and more |
| 2 | **Android permissions model** | Android blocks sensitive capabilities (internet, camera, location) unless explicitly declared |
| 3 | **Principle of least privilege** | Apps should only have the access they actually need |
| 4 | **XML syntax** — tags, attributes, self-closing tags | The format used for Android and iOS config files |
| 5 | **`http` vs `https`** | iOS restricts plain `http` by default; always prefer `https` in production |
