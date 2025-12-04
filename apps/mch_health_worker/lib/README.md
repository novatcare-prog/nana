# MCH Kenya - Digital Mother & Child Health System

[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-green.svg)](https://supabase.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.1.0-orange.svg)](https://github.com/novatcare-prog/nana/releases)

A comprehensive Flutter-based digital health system that digitizes Kenya's Mother and Child Health (MCH) Handbook 2020 guidelines. Built for healthcare workers to efficiently track maternal and child health services from pregnancy through early childhood.

---

## 📋 Table of Contents

- [Overview](#overview)
- [What's New in v1.1.0](#whats-new-in-v110)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [System Architecture](#system-architecture)
- [Getting Started](#getting-started)
- [Database Schema](#database-schema)
- [Project Structure](#project-structure)
- [Development Roadmap](#development-roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

**MCH Kenya** is a production-ready digital health platform designed to modernize maternal and child healthcare delivery in Kenya. The system digitizes all aspects of the Kenya MCH Handbook 2020, providing health workers with an efficient tool for:

- **Maternal Health Tracking**: From first ANC visit through postnatal care
- **Child Health Monitoring**: Growth, immunizations, and developmental milestones
- **Clinical Decision Support**: Built-in guidelines and reminders
- **Data Management**: Comprehensive patient records with offline capabilities

### 🎯 Project Goals

- Reduce paperwork and improve data quality in health facilities
- Ensure adherence to Kenya's MCH Handbook 2020 guidelines
- Enable data-driven decision making for maternal and child health programs
- Provide seamless offline-first experience for rural health facilities

---

## 🎉 What's New in v1.1.0

### 🔐 Password Reset & Recovery System (NEW)
- ✅ **Email-based password reset** with Supabase Auth integration
- ✅ **Hybrid deep linking** - Automatic app opening on Android/iOS
- ✅ **Manual fallback** for Windows and web platforms
- ✅ **Password strength validation** (8 characters, uppercase, lowercase, number, special character)
- ✅ **PKCE flow** for enhanced security
- ✅ **24-hour link expiration** with one-time use tokens

### 👤 Settings & User Preferences (NEW)
- ✅ **Comprehensive settings screen** with organized sections
- ✅ **Profile management** - View user info, role, and facility
- ✅ **Notification preferences** - Control appointment, immunization, and visit reminders
- ✅ **App preferences** - Theme selection, language, and data sync options
- ✅ **About section** - App version, MCH Handbook info, and support links

### 🌙 Dark Theme Support (NEW)
- ✅ **Three theme modes** - Light, Dark, and System Default
- ✅ **Persistent preferences** - Theme choice saved with SharedPreferences
- ✅ **Material Design 3** compliant
- ✅ **Instant switching** - No app restart required
- ✅ **Consistent branding** - Teal primary color maintained across themes

### ✏️ Edit Profile Feature (NEW)
- ✅ **Editable fields** - Full name, phone number, and facility selection
- ✅ **Real-time validation** - Input validation with error messages
- ✅ **Smart save button** - Appears only when changes are made
- ✅ **Loading states** - Visual feedback during save operations
- ✅ **Auto-refresh** - Profile updates immediately after save

### 📅 Calendar Improvements (NEW)
- ✅ **Color-coded markers** based on appointment status:
  - 🔴 **Red** - Missed appointments (highest priority)
  - 🟠 **Orange** - Pending/Scheduled appointments
  - 🟢 **Green** - All appointments completed
- ✅ **Real-time updates** - Markers refresh automatically on status changes
- ✅ **Enhanced visual feedback** - Better user experience
- ✅ **Month summary** - Quick stats for total, done, and pending appointments

### 📦 New Dependencies
- `package_info_plus: ^8.0.0` - App version information
- `shared_preferences: ^2.2.0` - Persistent theme storage

### 🔧 Technical Improvements
- Deep linking configuration for Android (AndroidManifest.xml)
- Deep linking configuration for iOS (Info.plist)
- Theme provider with Riverpod state management
- Enhanced calendar logic with status-based coloring
- Improved security with PKCE authentication flow

---

## ✨ Features

### 👤 User Management
- ✅ Health worker authentication (email/password)
- ✅ Role-based access control
- ✅ User profiles with facility information
- ✅ **Password reset functionality** (NEW in v1.1.0)
- ✅ **Edit profile capabilities** (NEW in v1.1.0)
- ⏳ Multi-factor authentication (planned)

### 🤰 Maternal Health Services

#### ANC (Antenatal Care) Visits
- ✅ Complete visit tracking (ANC 1-8+)
- ✅ Vital signs monitoring (BP, temperature, weight)
- ✅ Fundal height & fetal heart rate tracking
- ✅ Danger signs screening
- ✅ Birth preparedness counseling
- ✅ Visit history with chronological timeline

#### Maternal Immunizations
- ✅ Tetanus Toxoid (TT1-TT5) tracking
- ✅ Dose scheduling and due date calculations
- ✅ Immunization card view
- ✅ Protection status indicators

#### Malaria Prevention
- ✅ IPTp (Intermittent Preventive Treatment) tracking
- ✅ SP dose scheduling (IPTp1-IPTp5)
- ✅ Compliance monitoring

#### Nutrition Tracking
- ✅ MUAC (Mid-Upper Arm Circumference) measurements
- ✅ Weight monitoring throughout pregnancy
- ✅ Nutritional status assessment
- ✅ Counseling documentation
- ✅ Trends visualization

#### Childbirth & Delivery
- ✅ Comprehensive delivery recording
- ✅ Mode of delivery tracking
- ✅ Birth outcomes documentation
- ✅ Complications tracking
- ✅ Newborn information capture

#### Postnatal Care
- ✅ Visit tracking (48 hours, 6 days, 6 weeks, 6 months)
- ✅ Mother's health assessment (vitals, complications)
- ✅ Maternal danger signs monitoring
- ✅ Mental health screening
- ✅ Baby health monitoring (feeding, cord care, jaundice)
- ✅ Breastfeeding support tracking
- ✅ Family planning counseling
- ✅ Immunizations given during visits

### 👶 Child Health Services

#### Child Profile Management
- ✅ Complete child registration
- ✅ Birth information recording
- ✅ Family linkage to maternal profile
- ✅ Multiple children per mother support

#### Growth Monitoring
- ✅ Weight, length/height, head circumference tracking
- ✅ Age-appropriate measurement prompts
- ✅ Growth history with trend analysis
- ✅ Malnutrition screening
- ✅ WHO growth standards reference
- ⏳ Growth charts visualization (planned)

#### Child Immunizations
- ✅ Complete Kenya EPI schedule (Birth - 18 months)
- ✅ Vaccine tracking: BCG, Polio, DPT-HepB-Hib, PCV, Rota, Measles-Rubella, Vitamin A
- ✅ Due date calculations
- ✅ Catch-up scheduling
- ✅ Immunization card view
- ✅ Dose history with dates and batch numbers

#### Vitamin A Supplementation
- ✅ Dose tracking (6-59 months)
- ✅ 100,000 IU (6-11 months) and 200,000 IU (12+ months)
- ✅ 6-month interval scheduling
- ✅ Eligibility checking
- ✅ Complete dose history

#### Deworming
- ✅ Albendazole/Mebendazole tracking (12-59 months)
- ✅ 6-month interval scheduling
- ✅ Side effects monitoring
- ✅ Drug name and dosage recording
- ✅ Eligibility checking

#### Developmental Milestones
- ✅ Age-appropriate milestone assessments (6 weeks - 5 years)
- ✅ Multiple developmental domains:
  - Gross motor skills
  - Fine motor skills
  - Language & communication
  - Social & emotional development
  - Cognitive development
- ✅ Red flag identification
- ✅ Intervention planning
- ✅ Referral tracking
- ✅ Assessment history

### 📊 Clinical Management

#### Lab Results
- ✅ Comprehensive test result tracking
- ✅ Multiple test types (Hb, Blood group, HIV, Syphilis, Urinalysis, etc.)
- ✅ Result interpretation and flags
- ✅ Historical trends
- ✅ Test date tracking

#### Appointments & Scheduling
- ✅ Appointment booking system
- ✅ **Color-coded calendar view** (NEW in v1.1.0)
- ✅ Multiple visit types support
- ✅ Date and time scheduling
- ✅ Notes and instructions
- ✅ Appointment history
- ✅ **Status tracking with visual indicators** (NEW in v1.1.0)

### 📱 Patient Management

#### Patient Records
- ✅ Complete maternal profile creation
- ✅ Demographics and contact information
- ✅ Medical history capture
- ✅ Risk factor assessment
- ✅ Next of kin information
- ✅ Facility registration details

#### Data Operations
- ✅ Patient search and filtering
- ✅ Record editing and updates
- ✅ Comprehensive detail views
- ✅ Tabbed interface for organized data access
- ✅ Child-mother linkage

### 💾 Data Management

#### Offline Capabilities
- ✅ Offline-first architecture with Hive
- ✅ Local data caching
- ✅ Automatic sync when online
- ✅ Connectivity status monitoring
- ✅ Sync conflict resolution

#### Data Security
- ✅ Row-Level Security (RLS) in Supabase
- ✅ Role-based access control
- ✅ Secure authentication with JWT tokens
- ✅ **PKCE flow for enhanced security** (NEW in v1.1.0)
- ✅ Data encryption in transit
- ✅ Audit trail timestamps

### 🎨 User Experience (NEW in v1.1.0)
- ✅ **Dark theme support** (Light/Dark/System modes)
- ✅ **Persistent preferences** with local storage
- ✅ Responsive design (Mobile, Tablet, Desktop)
- ✅ Adaptive navigation (Bottom nav for mobile, Rail for desktop)
- ✅ Material Design 3
- ✅ Teal color scheme (Kenya MCH branding)
- ✅ Professional UI/UX

---

## 🛠️ Technology Stack

### Frontend
- **Framework**: Flutter 3.24.5
- **Language**: Dart
- **State Management**: Riverpod 2.x
- **Local Storage**: Hive
- **Preferences**: SharedPreferences (NEW in v1.1.0)
- **Code Generation**: Freezed, JSON Serializable
- **UI Components**: Material Design 3

### Backend
- **BaaS**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth with PKCE flow (Enhanced in v1.1.0)
- **Database**: PostgreSQL 15+
- **Real-time**: Supabase Realtime (WebSockets)
- **Storage**: Supabase Storage (future use)

### Development Tools
- **Version Control**: Git & GitHub
- **Code Quality**: Dart Analyzer
- **Build System**: Flutter Build Runner
- **Platforms**: Windows, Android (iOS ready)

---

## 🏗️ System Architecture

### Application Architecture

```
MCH Kenya App
│
├── 📱 Frontend (Flutter)
│   ├── mch_health_worker (Health worker app)
│   │   ├── Features
│   │   │   ├── Authentication (with password reset)
│   │   │   ├── Settings & Preferences (NEW)
│   │   │   ├── Profile Management (NEW)
│   │   │   └── Patient Management
│   │   └── Core
│   │       ├── Theme Provider (NEW)
│   │       └── Other Providers
│   ├── mch_patient (Patient app - future)
│   └── mch_core (Shared package)
│       ├── Models (Freezed/JSON Serializable)
│       ├── Repositories (Data access layer)
│       └── Utilities (Helpers & extensions)
│
├── ☁️ Backend (Supabase)
│   ├── PostgreSQL Database
│   │   ├── 15+ tables with relationships
│   │   ├── Indexes for performance
│   │   └── Row-Level Security policies
│   ├── Authentication (JWT-based + PKCE)
│   └── Real-time subscriptions
│
└── 💾 Local Storage
    ├── Hive (Patient data cache)
    └── SharedPreferences (User preferences)
```

### Data Flow

```
User Action → Riverpod Provider → Repository → Supabase/Hive → UI Update
                                      ↓
                                  Sync Manager (when online)
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.24.5 or higher
- Dart SDK 3.5.0 or higher
- Supabase account and project
- Git
- Code editor (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/novatcare-prog/nana.git
   cd nana
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   
   Create `.env` file in `apps/mch_health_worker/`:
   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Configure Password Reset (v1.1.0)**
   
   In Supabase Dashboard:
   - Go to Authentication → URL Configuration
   - Add redirect URLs:
     - `mchkenya://reset-password`
     - `mchkenya://auth-callback`
   - Customize email templates under Authentication → Email Templates

5. **Run database migrations**
   
   Execute SQL files in order from `/database/`:
   - `01_auth_setup.sql`
   - `02_maternal_profiles.sql`
   - `03_anc_visits.sql`
   - ... (all numbered SQL files)

6. **Generate code**
   ```bash
   cd packages/mch_core
   dart run build_runner build --delete-conflicting-outputs
   ```

7. **Run the app**
   ```bash
   cd apps/mch_health_worker
   flutter run
   ```

### Deep Linking Setup (v1.1.0)

**Android** (Already configured in AndroidManifest.xml):
- Custom scheme: `mchkenya://`
- Hosts: `reset-password`, `auth-callback`

**iOS** (Already configured in Info.plist):
- URL Scheme: `mchkenya`
- Deep linking enabled

**Windows/Web**:
- Manual code entry fallback available

### Database Setup (Supabase)

1. Create a new Supabase project
2. Go to SQL Editor
3. Execute all SQL files from `/database/` in numerical order
4. Verify tables are created in Database → Tables
5. Check RLS policies are active in Authentication → Policies

### First Login

Default test credentials (if sample data loaded):
- Email: `healthworker@test.com`
- Password: `password123`

**⚠️ Important**: Change default passwords in production!

---

## 🗄️ Database Schema

### Core Tables

#### User Management
- `user_profiles` - Health worker profiles with facility info

#### Maternal Health
- `maternal_profiles` - Patient demographics and obstetric history
- `anc_visits` - Antenatal care visit records
- `maternal_immunizations` - TT vaccine doses
- `malaria_prevention` - IPTp doses
- `nutrition_tracking` - MUAC and weight measurements
- `childbirth_records` - Delivery information
- `postnatal_visits` - Postnatal care visits

#### Child Health
- `child_profiles` - Child demographics and birth info
- `growth_records` - Weight, height, head circumference
- `child_immunizations` - Vaccine doses
- `vitamin_a_supplementation` - Vitamin A doses
- `deworming` - Deworming treatments
- `developmental_milestones` - Developmental assessments

#### Clinical
- `lab_results` - Laboratory test results
- `appointments` - Scheduled visits

### Relationships

```
maternal_profiles (1) ─────< (M) anc_visits
      │                          
      │ (1)                      
      │                          
      └─────< (M) child_profiles ─────< (M) growth_records
                      │                       │
                      │                       ├─< immunizations
                      │                       ├─< vitamin_a
                      │                       ├─< deworming
                      │                       └─< milestones
                      │
                      └─────< (M) postnatal_visits
```

---

## 📁 Project Structure

```
mch_kenya/
│
├── apps/
│   └── mch_health_worker/          # Health worker Flutter app
│       ├── lib/
│       │   ├── core/
│       │   │   ├── providers/      # Riverpod providers
│       │   │   │   ├── auth_providers.dart
│       │   │   │   ├── theme_provider.dart (NEW in v1.1.0)
│       │   │   │   └── appointment_providers.dart
│       │   │   ├── services/       # Business logic
│       │   │   └── widgets/        # Reusable widgets
│       │   │
│       │   └── features/
│       │       ├── auth/           # Authentication
│       │       │   └── presentation/screens/
│       │       │       ├── login_screen.dart
│       │       │       ├── forgot_password_screen.dart (NEW)
│       │       │       ├── reset_password_screen.dart (NEW)
│       │       │       └── enter_reset_code_screen.dart (NEW)
│       │       │
│       │       ├── dashboard/      # Main dashboard
│       │       └── patient_management/
│       │           ├── data/       # (deprecated - moved to mch_core)
│       │           └── presentation/
│       │               └── screens/  # All UI screens
│       │                   ├── settings_screen.dart (NEW)
│       │                   ├── edit_profile_screen.dart (NEW)
│       │                   └── schedule_screen.dart (UPDATED)
│       │
│       ├── android/
│       │   └── app/src/main/AndroidManifest.xml (UPDATED)
│       ├── ios/
│       │   └── Runner/Info.plist (UPDATED)
│       ├── windows/                # Windows config
│       └── pubspec.yaml            # (UPDATED with new deps)
│
├── packages/
│   └── mch_core/                   # Shared core package
│       ├── lib/
│       │   ├── src/
│       │   │   ├── models/         # Data models
│       │   │   │   ├── maternal/   # Maternal health models
│       │   │   │   ├── child/      # Child health models
│       │   │   │   └── users/      # User models
│       │   │   │
│       │   │   ├── data/
│       │   │   │   └── repositories/  # Data access layer
│       │   │   │
│       │   │   ├── enums/          # Enumerations
│       │   │   └── utils/          # Utility functions
│       │   │
│       │   └── mch_core.dart       # Package exports
│       │
│       └── pubspec.yaml
│
├── database/                        # SQL migration files
│   ├── 01_auth_setup.sql
│   ├── 02_maternal_profiles.sql
│   └── ... (all table schemas)
│
├── docs/                           # Documentation
│   ├── API.md
│   ├── SETUP.md
│   ├── USER_GUIDE.md
│   ├── MCH_Kenya_Development_Summary.pdf (NEW)
│   ├── PASSWORD_RESET_SETUP_GUIDE.md (NEW)
│   ├── DARK_THEME_GUIDE.md (NEW)
│   └── SETTINGS_INTEGRATION_GUIDE.md (NEW)
│
├── .gitignore
├── README.md                       # (UPDATED for v1.1.0)
├── LICENSE
└── pubspec.yaml                    # Root workspace config
```

---

## 🗺️ Development Roadmap

### ✅ Completed (v1.1.0) - December 4, 2025
- ✅ Password reset system with email verification
- ✅ Hybrid deep linking (Android/iOS + manual fallback)
- ✅ Comprehensive settings screen
- ✅ Dark theme support with persistence
- ✅ Edit profile functionality
- ✅ Color-coded calendar markers
- ✅ Enhanced security with PKCE flow
- ✅ 25 files delivered with complete documentation

### ✅ Completed (v1.0.0) - November 2025
- ✅ Complete MCH Handbook 2020 digitization
- ✅ Offline-first architecture
- ✅ 14 major feature modules
- ✅ Comprehensive data models
- ✅ Patient-provider workflows

### 🔄 In Progress
- [ ] Performance optimization
- [ ] Comprehensive testing suite
- [ ] User acceptance testing

### 📋 Planned Features (v1.2.0)

#### High Priority
- [ ] **Push Notifications**
  - Firebase Cloud Messaging integration
  - Appointment reminders
  - Immunization due dates
  - Visit scheduling alerts
  
- [ ] **WHO Growth Charts**
  - Visual growth curve plotting
  - Z-score calculations
  - Growth trend analysis
  - Malnutrition identification

- [ ] **Profile Photo Upload**
  - Avatar image support
  - Camera/gallery selection
  - Image compression

#### Medium Priority
- [ ] **Reports & Analytics**
  - Patient summary reports
  - Service statistics dashboard
  - Immunization coverage reports
  - Export to PDF/Excel

- [ ] **Enhanced Offline Mode**
  - Improved conflict resolution
  - Batch sync optimization
  - Offline queue management

- [ ] **Search & Filtering**
  - Advanced patient search
  - Filter by risk factors
  - Due date filtering
  - Visit status filtering

#### Future Enhancements (v1.3.0+)
- [ ] **Patient Mobile App**
  - Patient-facing mobile app
  - Appointment booking
  - Health records access
  - Educational content

- [ ] **Multi-language Support**
  - Swahili translation
  - Local language support
  - Dynamic language switching

- [ ] **Integration APIs**
  - DHIS2 integration
  - National reporting systems
  - Referral systems integration

- [ ] **Telemedicine**
  - Video consultations
  - Chat with health workers
  - Remote monitoring

- [ ] **AI/ML Features**
  - Risk prediction models
  - Automated growth assessment
  - Anomaly detection

---

## 📱 Platform Support

| Feature | Android | iOS | Windows | Web |
|---------|---------|-----|---------|-----|
| Core App | ✅ | ✅ | ✅ | ✅ |
| Password Reset (Deep Link) | ✅ | ✅ | Manual | Manual |
| Password Reset (Fallback) | ✅ | ✅ | ✅ | ✅ |
| Dark Theme | ✅ | ✅ | ✅ | ✅ |
| Offline Storage | ✅ | ✅ | ✅ | ✅ |
| Settings & Preferences | ✅ | ✅ | ✅ | ✅ |
| Push Notifications | ⏳ | ⏳ | ❌ | ❌ |

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### Getting Started

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart best practices
- Use Riverpod for state management
- Write meaningful commit messages
- Add tests for new features
- Update documentation

### Code Style

- Run `dart format .` before committing
- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic

### Reporting Issues

- Use GitHub Issues
- Include steps to reproduce
- Provide screenshots if applicable
- Mention Flutter/Dart versions

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

**Novatcare Technologies**
- GitHub: [@novatcare-prog](https://github.com/novatcare-prog)
- Developer: Tony Olchugen

---

## 🙏 Acknowledgments

- **Ministry of Health, Kenya** - For the MCH Handbook 2020 guidelines
- **Flutter Team** - For the amazing framework
- **Supabase** - For the backend infrastructure
- **Open Source Community** - For the incredible packages and tools

---

## 📞 Support

For questions, issues, or support:
- 📧 Email: support@novatcare.com
- 🐛 Issues: [GitHub Issues](https://github.com/novatcare-prog/nana/issues)
- 📖 Docs: [Documentation](https://github.com/novatcare-prog/nana/wiki)

---

## 🌟 Star History

If this project helps you, please consider giving it a ⭐ on GitHub!

---

## 📊 Project Stats

- **Languages**: Dart, SQL
- **Lines of Code**: ~18,000+ (updated in v1.1.0)
- **Database Tables**: 15+
- **Models**: 20+
- **Screens**: 45+ (5 new in v1.1.0)
- **Contributors**: Open for contributions!

---

## 📋 Version History

### v1.1.0 (December 4, 2025) - Latest Release ✨

**New Features:**
- ✅ Password reset system with email verification
- ✅ Hybrid deep linking (automatic + manual fallback)
- ✅ Comprehensive settings screen
- ✅ Dark theme support with persistence
- ✅ Edit profile functionality
- ✅ Color-coded calendar markers (Red/Orange/Green)

**Technical Improvements:**
- ✅ Enhanced security with PKCE flow
- ✅ Theme state management with Riverpod
- ✅ Deep linking configuration for Android/iOS
- ✅ Real-time calendar marker updates
- ✅ Password strength validation

**Documentation:**
- 📄 Complete PDF development summary (15 pages)
- 📖 6 comprehensive integration guides
- 🔧 Updated setup and configuration docs

**Files Changed:** 17 files | **Files Added:** 8 files | **Total Deliverables:** 25 files

### v1.0.0 (November 2025)
- ✅ Complete MCH Handbook 2020 implementation
- ✅ 14 major features
- ✅ Offline-first architecture
- ✅ Multi-platform support

---

**Built with ❤️ for better maternal and child healthcare in Kenya**

**🌟 Star this repo if you find it useful!**