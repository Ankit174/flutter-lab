# Temperature Converter Mobile Application - Detailed Project Report

---

## 1. Executive Summary

The **Temperature Converter** is a cross-platform mobile application developed using **Flutter** and **Dart**. Designed with **Material 3 principles**, the app enables users to seamlessly convert temperature values between **Celsius (°C)**, **Fahrenheit (°F)**, and **Kelvin (K)**. 

The application incorporates strict input validation based on physical laws (Absolute Zero), local data persistence for conversion history and theme preference via **SharedPreferences**, interactive quick conversion presets, smooth animations, and a responsive layout tailored for mobile and web screens.

---

## 2. Project Specifications

| Attribute | Details |
| :--- | :--- |
| **Application Name** | Temperature Converter |
| **Framework & Language** | Flutter 3.x / Dart 3.x |
| **Design System** | Material 3 (Material Design 3) |
| **State Management** | Native `StatefulWidget` & Callbacks (Zero external framework overhead) |
| **Persistence** | `shared_preferences: ^2.2.2` |
| **Target Platforms** | Android, iOS, Web, Windows Desktop |
| **Code Structure** | Clean Layered Architecture (`models/`, `services/`, `widgets/`, `screens/`, `utils/`) |

---

## 3. Project Directory Structure

```
c:\Users\sky88\OneDrive\Desktop\flutter pr\
├── pubspec.yaml                       # Project metadata and dependencies
├── run_app.bat                        # One-click launch script
├── project_report.md                  # Project detailed documentation report
├── test/
│   └── conversion_service_test.dart   # Automated unit test suite (12 tests)
└── lib/
    ├── main.dart                      # Root application entrypoint & theme setup
    ├── models/
    │   └── conversion.dart            # TemperatureUnit enum & ConversionRecord model
    ├── services/
    │   └── conversion_service.dart    # Pure math formulas, validation & formatting
    ├── utils/
    │   └── constants.dart             # Color palette, storage keys & quick presets
    ├── widgets/
    │   ├── temperature_input.dart     # Styled numeric input with clear button
    │   ├── unit_dropdown.dart         # Material 3 dropdown selector
    │   ├── result_card.dart           # Animated card displaying results & formulas
    │   └── history_list.dart          # Conversion history view with delete options
    └── screens/
        └── home_screen.dart           # Primary UI screen & state management controller
```

---

## 4. Mathematical Model & Conversion Formulas

The application implements standard thermodynamic temperature conversion equations:

### 4.1 Conversion Matrix

1. **Celsius (°C) → Fahrenheit (°F)**:
   $$F = \left(C \times \frac{9}{5}\right) + 32$$

2. **Fahrenheit (°F) → Celsius (°C)**:
   $$C = (F - 32) \times \frac{5}{9}$$

3. **Celsius (°C) → Kelvin (K)**:
   $$K = C + 273.15$$

4. **Kelvin (K) → Celsius (°C)**:
   $$C = K - 273.15$$

5. **Fahrenheit (°F) → Kelvin (K)**:
   $$K = (F - 32) \times \frac{5}{9} + 273.15$$

6. **Kelvin (K) → Fahrenheit (°F)**:
   $$F = (K - 273.15) \times \frac{9}{5} + 32$$

7. **Same Unit Conversion**:
   $$\text{Result} = \text{Input}$$

### 4.2 Absolute Zero Boundary Limits

Per physical laws, absolute zero is the lower limit of thermodynamic temperature scale:

- **Kelvin ($K$)**: $0.0\text{ K}$
- **Celsius ($^\circ\text{C}$)**: $-273.15^\circ\text{C}$
- **Fahrenheit ($^\circ\text{F}$)**: $-459.67^\circ\text{F}$

Input lower than these values is blocked by `ConversionService.validateInput()` with an explicit error message preventing impossible computations.

---

## 5. Core Features & Technical Implementation

### 5.1 Unit Conversion Engine (`lib/services/conversion_service.dart`)
- **Separation of Concerns**: Pure mathematical functions isolated from Flutter UI rendering.
- **Clean Number Formatting**: Truncates unnecessary trailing zeros (e.g., `25.000` $\rightarrow$ `25`, `373.1500` $\rightarrow$ `373.15`).
- **Formula Hints**: Provides explicit mathematical steps rendered dynamically on the result card.

### 5.2 Unit Swap & Reset
- **Unit Swap**: Tapping the swap button exchanges the "From" and "To" units and automatically recalculates results if valid text is present.
- **Reset**: Clears all input fields, resets errors, restores defaults (°C to °F), and clears active results.

### 5.3 Quick Example Presets
Provides interactive chip buttons for instantaneous conversions:
- Freezing Point: $0^\circ\text{C} = 32^\circ\text{F}$
- Boiling Point: $100^\circ\text{C} = 212^\circ\text{F}$
- Absolute Zero: $0^\circ\text{C} = 273.15\text{K}$
- Human Body Temp: $37^\circ\text{C} = 98.6^\circ\text{F}$

### 5.4 Data Persistence (`SharedPreferences`)
- **Theme Mode**: Persists Light/Dark theme selection using `is_dark_mode` key.
- **Conversion History**: Encodes recent conversion records into JSON objects stored under `conversion_history_v1`. Supports single item deletion and full history clear.

---

## 6. Software Quality Assurance & Unit Testing

A comprehensive unit test suite (`test/conversion_service_test.dart`) was created and verified using `flutter test`:

| Test Category | Test Case Description | Status |
| :--- | :--- | :---: |
| **Logic** | Celsius ↔ Fahrenheit conversions ($0^\circ\text{C} \rightarrow 32^\circ\text{F}$, $-40^\circ\text{C} \rightarrow -40^\circ\text{F}$) | **PASSED** |
| **Logic** | Celsius ↔ Kelvin conversions ($0^\circ\text{C} \rightarrow 273.15\text{K}$, $100^\circ\text{C} \rightarrow 373.15\text{K}$) | **PASSED** |
| **Logic** | Fahrenheit ↔ Kelvin conversions ($32^\circ\text{F} \rightarrow 273.15\text{K}$) | **PASSED** |
| **Validation** | Rejection of empty / whitespace inputs | **PASSED** |
| **Validation** | Rejection of non-numeric characters | **PASSED** |
| **Validation** | Absolute zero violation checks (e.g., $-1\text{ K}$, $-274^\circ\text{C}$, $-460^\circ\text{F}$) | **PASSED** |
| **Formatting** | Trailing zero elimination ($25.0 \rightarrow 25$) & Decimal precision rounding | **PASSED** |

---

## 7. Instructions for Deployment & Execution

### 7.1 Local Development Execution
```bash
# Navigate to directory
cd "c:\Users\sky88\OneDrive\Desktop\flutter pr"

# Fetch packages
flutter pub get

# Run unit tests
flutter test

# Run app on Chrome / Desktop / Device
flutter run -d chrome
```

### 7.2 Building Android Release APK
To generate a standalone APK file for Android:
```bash
flutter build apk --release
```
Output artifact path: `build/app/outputs/flutter-apk/app-release.apk`

---

## 8. Conclusion

The Temperature Converter application successfully fulfills all functional, architectural, design, and testing requirements specified. Its clean separation of business logic, Material 3 UI design, robust validation against physical constants, and offline data persistence make it a polished mobile project demonstration.
