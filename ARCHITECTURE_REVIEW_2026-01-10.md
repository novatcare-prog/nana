# MCH Kenya System - Architecture Review & Recommendations

**Review Date:** January 10, 2026  
**Reviewer:** AI Development Assistant

---

## 📊 System Overview

### Current Architecture

```
mch_kenya/
├── apps/
│   ├── mch_health_worker/    # Clinician/Health Worker App
│   └── mch_patient/          # Patient App (Nana)
│
└── packages/
    └── mch_core/             # Shared Core Package
        ├── models/           # Data models (Freezed)
        ├── repositories/     # Database access layer
        └── enums/            # Shared enumerations
```

### Technology Stack
| Component | Technology |
|-----------|------------|
| Frontend | Flutter 3.24.5 |
| State Management | Riverpod 2.x |
| Backend | Supabase (PostgreSQL) |
| Auth | Supabase Auth (PKCE) |
| Offline Storage | Hive |
| Code Generation | Freezed, JSON Serializable |

---

## ✅ What's Working Well

### 1. **Shared Core Package (mch_core)**
- ✅ Good separation of concerns
- ✅ Models shared between apps
- ✅ Repositories centralized
- ✅ Single source of truth for data structures

### 2. **Feature-Based Architecture**
- ✅ Health Worker app uses feature folders (`anc_clinic`, `cwc_clinic`, etc.)
- ✅ Good separation between features

### 3. **Offline-First Design**
- ✅ Hive for local storage
- ✅ Connectivity monitoring
- ✅ Sync capabilities

### 4. **Security**
- ✅ PKCE flow for auth
- ✅ Role-based access control
- ✅ Facility-based data isolation

---

## ⚠️ Issues & Recommendations

### 1. **CRITICAL: Supabase Credentials Hardcoded**

**Issue:** In `mch_health_worker/main.dart`, Supabase URL and anon key are hardcoded:
```dart
await Supabase.initialize(
  url: 'https://fhdscavlgrgbotfxoxxw.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIs...',
);
```

**Risk:** 
- Keys visible in source code
- Can't change between environments (dev/staging/prod)
- Security vulnerability if repo is public

**Recommendation:**
```dart
// Use .env file like patient app does
await dotenv.load(fileName: ".env");
await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
);
```

**Priority:** 🔴 HIGH

---

### 2. **Inconsistent Architecture Between Apps**

**Issue:** Patient app and Health Worker app have different structures:

| Aspect | Patient App | Health Worker App |
|--------|-------------|-------------------|
| Main.dart | Simple, uses AppInitializer | Complex, inline initialization |
| Router | GoRouter | Navigator 1.0 |
| Splash | ConsumerStatefulWidget | StatefulWidget |
| Auth Flow | In router redirect | AuthGate widget |

**Recommendation:**
- Standardize on GoRouter for both apps
- Use same initialization pattern
- Create shared `app_initializer` in mch_core

**Priority:** 🟡 MEDIUM

---

### 3. **Duplicate Repositories**

**Issue:** Some repositories exist in both mch_core AND individual apps:

```
mch_core/lib/src/data/repositories/
├── maternal_profile_repository.dart
└── supabase_maternal_profile_repository.dart  ← Duplicate?
```

**Recommendation:**
- Audit all repositories
- Remove duplicates
- Ensure single source of truth

**Priority:** 🟡 MEDIUM

---

### 4. **Missing Appointment Repository Export**

**Issue:** `appointment_repository.dart` exists but isn't exported in `mch_core.dart`:

```dart
// In mch_core.dart
export 'src/models/appointment/appointment.dart';
// Missing: export 'src/data/repositories/appointment_repository.dart';
```

**Recommendation:** Add missing exports

**Priority:** 🟢 LOW

---

### 5. **mch_core Not Used Consistently**

**Issue:** Patient app's `pubspec.yaml` has mch_core commented out:

```yaml
# Shared Package (uncomment when mch_core package is ready)
# mch_core:
#   path: ../../packages/mch_core
```

But imports work because of path resolution. This could cause issues.

**Recommendation:** Uncomment and ensure proper dependency

**Priority:** 🟡 MEDIUM

---

### 6. **No Shared Notification Service**

**Issue:** Notifications implemented only in patient app. Health workers also need notifications for:
- Appointments they need to prepare for
- Patients with overdue visits
- High-risk patient alerts

**Recommendation:**
- Move NotificationService to mch_core
- Implement in health worker app
- Server-side push notifications via Firebase Cloud Messaging

**Priority:** 🟡 MEDIUM

---

### 7. **No Shared Theme System**

**Issue:** Both apps define their own themes separately:
- Patient: Pink/Rose theme
- Health Worker: Teal theme

**Recommendation:**
- Create theme factory in mch_core
- Share color palette definitions
- Easier to maintain consistent branding

```dart
// In mch_core
class MCHThemeFactory {
  static ThemeData patientLight() => ...
  static ThemeData patientDark() => ...
  static ThemeData healthWorkerLight() => ...
  static ThemeData healthWorkerDark() => ...
}
```

**Priority:** 🟢 LOW

---

### 8. **Offline Sync Improvements Needed**

**Issue per README:** Sync conflict resolution mentioned but implementation unclear.

**Recommendation:**
- Implement proper sync queue
- Add conflict resolution UI
- Show sync status to users
- Background sync using WorkManager

**Priority:** 🟡 MEDIUM

---

### 9. **No Error Reporting/Analytics**

**Issue:** No crash reporting or analytics visible in codebase.

**Recommendation:**
- Add Firebase Crashlytics
- Add Firebase Analytics or Mixpanel
- Track key user journeys
- Monitor app health

**Priority:** 🟡 MEDIUM

---

### 10. **Testing Gap**

**Issue:** Test folder in mch_core has only 1 file:

```
packages/mch_core/test/  (1 file)
```

**Recommendation:**
- Add unit tests for repositories
- Add widget tests for key screens
- Add integration tests for auth flow
- Target 70% coverage minimum

**Priority:** 🟡 MEDIUM

---

## 🔄 Recommended Migration Path

### Phase 1: Security & Stability (1-2 weeks)
1. ✅ Move Supabase credentials to .env in health worker app
2. ✅ Fix mch_core dependency in patient app
3. ✅ Add missing repository exports

### Phase 2: Architecture Alignment (2-3 weeks)
1. ⏳ Migrate health worker app to GoRouter
2. ⏳ Create shared AppInitializer in mch_core
3. ⏳ Standardize splash screen approach

### Phase 3: Feature Parity (3-4 weeks)
1. ⏳ Add notifications to health worker app
2. ⏳ Move NotificationService to mch_core
3. ⏳ Implement push notifications (Firebase)

### Phase 4: Quality (Ongoing)
1. ⏳ Add crash reporting
2. ⏳ Add analytics
3. ⏳ Increase test coverage

---

## 📋 Immediate Action Items

| # | Task | File/Location | Priority |
|---|------|---------------|----------|
| 1 | Add .env and flutter_dotenv to health worker | `mch_health_worker/` | 🔴 HIGH |
| 2 | Move credentials to .env | `main.dart` | 🔴 HIGH |
| 3 | Uncomment mch_core dependency | `mch_patient/pubspec.yaml` | 🟡 MEDIUM |
| 4 | Add appointment_repository export | `mch_core.dart` | 🟢 LOW |
| 5 | Remove duplicate repositories | `mch_core/repositories/` | 🟡 MEDIUM |

---

## 🎯 Recommended Next Features

Based on roadmap and system analysis:

| Feature | Reason | Effort |
|---------|--------|--------|
| **Push Notifications (FCM)** | Both apps need server-triggered alerts | 2-3 weeks |
| **WHO Growth Charts** | Critical for child health monitoring | 2 weeks |
| **PDF Export** | Patients need health records | 1 week |
| **Swahili Language** | User accessibility | 2 weeks |
| **DHIS2 Integration** | Government reporting requirement | 4+ weeks |

---

## 💡 Additional Suggestions

### 1. **Create Shared Constants**
```dart
// In mch_core
class MCHConstants {
  static const Duration sessionTimeout = Duration(hours: 24);
  static const int maxLoginAttempts = 5;
  static const List<String> kenyanCounties = [...];
}
```

### 2. **Add Logging Service**
```dart
// Centralized logging that can be filtered by level
MCHLogger.debug('Loading patients...');
MCHLogger.info('User logged in');
MCHLogger.error('Failed to sync', error);
```

### 3. **API Response Wrapper**
```dart
// Standardize API responses
class MCHResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
}
```

---

## 📊 Code Quality Metrics

| Metric | Current | Target |
|--------|---------|--------|
| Test Coverage | ~5% | 70%+ |
| Documentation | Partial | Full JSDoc |
| Lint Warnings | Unknown | 0 |
| Type Safety | Good | Strict |

---

## 🏁 Conclusion

The MCH Kenya system is well-architected with good separation between apps and shared code. The main areas needing attention are:

1. **Security** - Hardcoded credentials
2. **Consistency** - Different patterns between apps
3. **Testing** - Low test coverage
4. **Observability** - No crash/analytics

Addressing these will significantly improve maintainability and reliability.

---

*Report generated by AI Development Assistant*
*January 10, 2026*
