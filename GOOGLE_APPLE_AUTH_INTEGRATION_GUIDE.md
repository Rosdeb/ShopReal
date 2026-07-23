# Google / Apple Login + Signup + Verify — Full Integration Guide

Copy this auth stack into another Flutter project that uses the **same backend API**. This document mirrors exactly how ShopReal (`llc`) implements it.

---

## 1. High-level architecture

```
UI (LoginView / SignupView)
    ↓
AuthViewModel
    ├─ Email/password → AuthApiServiceImpl → Backend
    ├─ Google → GoogleSignInService → Firebase Auth → idToken → Backend OAuth
    └─ Apple  → AppleSignInService  → Firebase Auth → identityToken → Backend OAuth
```

**Important:** Google/Apple do **not** create the app session alone.  
Native/Firebase sign-in only produces an OAuth token. The real app login is:

`POST /auth/login/oauth` with `{ provider, oAuthToken, fcmToken? }`

Backend returns `accessToken` + `refreshToken` + user. App stores tokens in `GetStorage` and navigates to Home.

---

## 2. Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  # Auth / Firebase
  firebase_core: ^4.7.0
  firebase_auth: ^6.4.0
  cloud_firestore: 6.2.0          # optional sync only (Google)
  firebase_messaging: ^16.2.0     # FCM token sent on social login
  google_sign_in: ^7.2.0
  sign_in_with_apple: ^7.0.1
  crypto: ^3.0.3                  # Apple nonce hashing (used by AppleSign.dart)

  # Storage + HTTP (already used by auth API)
  get_storage: ^2.1.1
  http: ^1.1.0
  provider: ^6.1.1
```

Assets used by social buttons:

```yaml
flutter:
  assets:
    - images/google.svg
    - images/apple.svg
```

Then:

```bash
flutter pub get
```

---

## 3. Files to copy (same codebase)

| Purpose | Path |
|--------|------|
| Google native + Firebase | `lib/Services/googleSign.dart` |
| Apple native + Firebase | `lib/Services/AppleSign.dart` |
| Auth ViewModel (all flows) | `lib/presentation/viewmodels/auth/auth_viewmodel.dart` |
| Auth API interface | `lib/data/services/api/auth_api_service.dart` |
| Auth API implementation | `lib/data/services/api/auth_api_service_impl.dart` |
| Endpoints / base URL | `lib/core/constants/api_constants.dart` |
| Login UI | `lib/presentation/views/auth/login_view.dart` |
| Signup UI | `lib/presentation/views/auth/signup_screen.dart` |
| Email OTP verify UI | `lib/presentation/views/auth/email_verification_view.dart` |
| Forgot password UI | `lib/presentation/views/auth/forgor_screen_view.dart` |
| Reset password UI | `lib/presentation/views/auth/reset_password.dart` |
| Firebase options | `lib/firebase_options.dart` |
| Android Firebase config | `android/app/google-services.json` |
| iOS Firebase config | `ios/Runner/GoogleService-Info.plist` |

Also wire routes/bindings the same way (`AppRoutes.login`, `emailVerification`, `home`, etc.).

---

## 4. Backend API (same for all projects)

**Base URL (current project):**

```text
https://shopguard.xdtunnel.icu/api/v1
```

Defined in `ApiConstants.apiBaseUrl`.

### Auth endpoints

| Flow | Method | Endpoint | Body |
|------|--------|----------|------|
| Email login | `POST` | `/auth/login` | `{ "email", "password" }` |
| Register | `POST` | `/auth/register` | `{ "email", "password", "name"?, "role": "user" }` |
| Google / Apple OAuth | `POST` | `/auth/login/oauth` | `{ "provider": "google"\|"apple", "oAuthToken", "fcmToken"? }` |
| Verify account (OTP) | `POST` | `/auth/verify-account` | `{ "email", "code" }` |
| Resend OTP | `POST` | `/auth/resend-otp` | `{ "email" }` |
| Forgot password | `POST` | `/auth/forgot-password` | `{ "email" }` |
| Reset password | `POST` | `/auth/reset-password` | `{ "email", "otp", "password" }` |
| Logout | `POST` | `/auth/logout` | `{ "refreshToken"? }` + Bearer |
| Refresh tokens | `POST` | `/auth/refresh-tokens` | `{ "refreshToken" }` |

### OAuth request example

```json
{
  "provider": "google",
  "oAuthToken": "<Google idToken OR Apple identityToken>",
  "fcmToken": "<optional FCM token>"
}
```

Apple uses the same endpoint with `"provider": "apple"`.

### Token storage keys

- `auth_access_token`
- `auth_refresh_token`

Saved via `GetStorage` inside `AuthApiServiceImpl`.

---

## 5. Google Login (full flow)

### 5.1 Runtime flow

```
User taps Google
  → AuthViewModel.signWithGoogle()
  → GoogleSignInService.signInWithGoogle()
       1. GoogleSignIn.instance.initialize()
       2. authenticate(scopeHint: email, profile)
       3. Read idToken
       4. Get accessToken via authorizationClient
       5. FirebaseAuth.signInWithCredential(GoogleAuthProvider)
       6. Optional: sync user doc to Firestore users/{uid}
       7. Return { idToken, accessToken, email, ... }
  → AuthViewModel sends idToken as oAuthToken to POST /auth/login/oauth
  → Save user + tokens
  → Navigate to Home (AppRoutes.home)
```

Cancel (user closes Google sheet) → returns `null` → no error toast.

### 5.2 Core service (`lib/Services/googleSign.dart`)

Key points:

- Uses **google_sign_in v7** API: `GoogleSignIn.instance` + `authenticate()`
- App backend needs **`idToken`** (not accessToken)
- Firebase Auth is used so Google credential is validated locally
- Firestore sync is best-effort; failure does **not** block login

### 5.3 ViewModel call

```dart
final result = await GoogleSignInService.signInWithGoogle();
final idToken = result['idToken'];
final fcmToken = await FirebaseMessaging.instance.getToken(); // optional
final user = await _authApiService.loginWithGoogle(
  oAuthToken: idToken,
  fcmToken: fcmToken,
);
```

### 5.4 Android setup

1. Place `google-services.json` in `android/app/`.
2. Apply plugin in `android/settings.gradle.kts`:

```kotlin
id("com.google.gms.google-services") version("4.3.15") apply false
```

3. In `android/app/build.gradle.kts`:

```kotlin
id("com.google.gms.google-services")
```

4. Package name must match Firebase Android app  
   Current project: `com.shopreal.llc`

5. In Firebase Console → Authentication → Sign-in method → enable **Google**.

6. Add SHA-1 / SHA-256 of your debug/release keystore in Firebase Android app settings (required for Google Sign-In on Android).

### 5.5 iOS setup (Google)

1. Place `GoogleService-Info.plist` in `ios/Runner/`.
2. Add URL scheme in `ios/Runner/Info.plist` = `REVERSED_CLIENT_ID` from that plist.

Current project example:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.216387410941-4e7ce7s17trgok4rgiu4fceqa4eqv46m</string>
    </array>
  </dict>
</array>
```

3. Bundle ID must match Firebase iOS app: `com.shopreal.llc`

### 5.6 Firebase init (`lib/main.dart`)

```dart
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

---

## 6. Apple Login (full flow)

### 6.1 Runtime flow

```
User taps Apple (iOS / macOS only in UI)
  → AuthViewModel.signInWithApple()
  → AppleSignInService.signInWithApple()
       1. Generate rawNonce + sha256(nonce)
       2. SignInWithApple.getAppleIDCredential(scopes: email, fullName, nonce)
       3. Firebase OAuthProvider("apple.com").credential(idToken, rawNonce, authorizationCode)
       4. FirebaseAuth.signInWithCredential(...)
       5. Return { identityToken, email, displayName, uid, ... }
  → AuthViewModel sends identityToken as oAuthToken to POST /auth/login/oauth (provider: apple)
  → Save user + tokens
  → Navigate to Home
```

User cancel → silently ignored.

### 6.2 UI visibility

Apple button is shown only when:

```dart
Theme.of(context).platform == TargetPlatform.iOS ||
Theme.of(context).platform == TargetPlatform.macOS
```

Used in `login_view.dart`, `signup_screen.dart`, `register_view.dart`.

### 6.3 iOS native capability

`ios/Runner/Runner.entitlements`:

```xml
<key>com.apple.developer.applesignin</key>
<array>
  <string>Default</string>
</array>
```

Also enable **Sign In with Apple** capability in Xcode (Runner target → Signing & Capabilities).

### 6.4 Apple Developer / Firebase checklist

1. Apple Developer → App ID → enable **Sign In with Apple**
2. Firebase Console → Authentication → enable **Apple**
3. For Firebase Apple provider, configure Services ID / key if required by your Firebase project setup
4. Real device recommended (Simulator Apple ID behavior can be flaky)

### 6.5 Backend token note

App sends Apple **`identityToken`** (JWT), not authorizationCode, as `oAuthToken`.

---

## 7. Email Signup flow

```
SignupView
  → AuthViewModel.register()
  → POST /auth/register { email, password, name?, role: "user" }
  → Optionally persist tokens/user if returned
  → Navigate to EmailVerificationView(email)
```

Validation:

- Email valid
- Password valid
- `password == confirmPassword`

After register, user must verify OTP before normal login into home (see verify + login rules).

---

## 8. Email Verify flow

UI: `EmailVerificationView` — 6-digit OTP.

```
Enter 6 digits → Verify Code
  → AuthViewModel.verifyEmail(context, code, verifyFlag, emailOverride: email)
  → POST /auth/verify-account { email, code }
  → Navigate to Login (clear stack)
```

Resend:

```
AuthViewModel.sendCode()
  → POST /auth/resend-otp { email }
```

---

## 9. Email Login + unverified redirect

```
AuthViewModel.login()
  → POST /auth/login
  → if user.isEmailVerified == true → Home
  → else → EmailVerificationView(email)
```

Social Google/Apple skip this check in ViewModel: success goes straight to Home (backend is expected to treat OAuth users as verified / auto-created).

---

## 10. Forgot / Reset password

```
ForgotPasswordView
  → sendResetCode() → POST /auth/forgot-password
  → ResetPassword screen
  → user enters OTP + new password
  → resetPassword() → POST /auth/reset-password { email, otp, password }
  → back to Login
```

---

## 11. Copy-paste checklist for a new project (same API)

### A. Code

- [ ] Copy the auth service files + ViewModel + views listed in §3
- [ ] Keep endpoint paths in `ApiConstants` identical
- [ ] Point `apiBaseUrl` at the same backend (or your env)
- [ ] Keep OAuth body shape: `provider`, `oAuthToken`, optional `fcmToken`
- [ ] Initialize Firebase in `main()`
- [ ] Register auth routes (`login`, `signup`, `emailVerification`, `resetPassword`, `home`)

### B. Firebase / Google (if same Firebase project)

- [ ] Reuse same `google-services.json` / `GoogleService-Info.plist` / `firebase_options.dart`
- [ ] Or create new Firebase apps and regenerate those files
- [ ] Enable Google + Apple providers in Firebase Auth
- [ ] Match Android `applicationId` / iOS `bundleId`

### C. If **different** app package/bundle but **same API**

You must:

1. Create new Android/iOS apps in Firebase (or Google Cloud OAuth clients)
2. Download new config files
3. Update `Info.plist` URL scheme to new `REVERSED_CLIENT_ID`
4. Keep backend OAuth endpoint the same — backend verifies Google/Apple tokens independently of your Flutter package name

### D. Apple-only

- [ ] Enable Sign In with Apple entitlement
- [ ] Capability on App ID
- [ ] Test on physical iPhone

### E. Smoke test

1. Google login → Home + tokens stored  
2. Apple login (iOS) → Home + tokens stored  
3. Register → OTP screen → verify → login → Home  
4. Unverified email login → forced to OTP screen  
5. Forgot password → OTP → reset → login  

---

## 12. Minimal code map (what calls what)

| UI action | ViewModel method | Native service | API method | Endpoint |
|-----------|------------------|----------------|------------|----------|
| Tap Google | `signWithGoogle` | `GoogleSignInService.signInWithGoogle` | `loginWithGoogle` | `/auth/login/oauth` |
| Tap Apple | `signInWithApple` | `AppleSignInService.signInWithApple` | `loginWithApple` | `/auth/login/oauth` |
| Sign Up | `register` | — | `register` | `/auth/register` |
| Verify OTP | `verifyEmail` | — | `verifyResetCode` | `/auth/verify-account` |
| Resend OTP | `sendCode` | — | `resendCode` | `/auth/resend-otp` |
| Login | `login` | — | `login` | `/auth/login` |
| Forgot | `sendResetCode` | — | `forgotPassword` | `/auth/forgot-password` |
| Reset | `resetPassword` | — | `resetPassword` | `/auth/reset-password` |
| Logout | `logout` | — | `logout` | `/auth/logout` |

---

## 13. Current project IDs (reference)

| Item | Value |
|------|-------|
| Firebase project | `shopreal-71605` |
| Android package | `com.shopreal.llc` |
| iOS bundle | `com.shopreal.llc` |
| Android OAuth web client | `216387410941-84g359m34sdqdkrot00l68q6anqrak8m.apps.googleusercontent.com` |
| iOS OAuth client | `216387410941-4e7ce7s17trgok4rgiu4fceqa4eqv46m.apps.googleusercontent.com` |
| API base | `https://shopguard.xdtunnel.icu/api/v1` |

---

## 14. Common failures

| Symptom | Likely cause |
|---------|--------------|
| Google cancel / no sheet | Missing SHA-1 (Android) or wrong package name |
| iOS Google redirects fail | Wrong/missing `REVERSED_CLIENT_ID` URL scheme |
| `ID Token is null` | Google Sign-In / Firebase OAuth client misconfigured |
| Apple button missing | Not running on iOS/macOS |
| Apple fails immediately | Entitlement / capability not enabled |
| OAuth API 401/400 | Backend cannot verify token (wrong provider secret / audience) |
| Login goes to OTP always | `isEmailVerified` false from `/auth/login` response |
| Tokens missing after OAuth | Response shape not parsed — check `_extractToken` / `_extractUserPayload` |

---

## 15. One-sentence summary

**Copy the auth Dart files + Firebase configs, keep `/auth/*` endpoints the same, wire Google `idToken` / Apple `identityToken` into `POST /auth/login/oauth`, and keep signup → OTP verify → login as the email path.**
