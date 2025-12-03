# MCH Kenya - Digital Mother & Child Health System

[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-green.svg)](https://supabase.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)](https://github.com/novatcare-prog/nana/releases)

A comprehensive Flutter-based digital health system that digitizes Kenya's Mother and Child Health (MCH) Handbook 2020 guidelines. Built for healthcare workers to efficiently track maternal and child health services from pregnancy through early childhood.

---

## 📋 Table of Contents

- [Overview](#overview)
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

## ✨ Features

### 👤 User Management
- ✅ Health worker authentication (email/password)
- ✅ Role-based access control
- ✅ User profiles with facility information
- ⏳ Password reset functionality (planned)
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
- ✅ Multiple visit types support
- ✅ Date and time scheduling
- ✅ Notes and instructions
- ✅ Appointment history

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
- ✅ Data encryption in transit
- ✅ Audit trail timestamps

---

## 🛠️ Technology Stack

### Frontend
- **Framework**: Flutter 3.24.5
- **Language**: Dart
- **State Management**: Riverpod 2.x
- **Local Storage**: Hive
- **Code Generation**: Freezed, JSON Serializable
- **UI Components**: Material Design 3

### Backend
- **BaaS**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
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
│   ├── Authentication (JWT-based)
│   └── Real-time subscriptions
│
└── 💾 Local Storage (Hive)
    ├── Patient data cache
    ├── Visit records
    └── Sync queue
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

4. **Run database migrations**
   
   Execute SQL files in order from `/database/`:
   - `01_auth_setup.sql`
   - `02_maternal_profiles.sql`
   - `03_anc_visits.sql`
   - ... (all numbered SQL files)

5. **Generate code**
   ```bash
   cd packages/mch_core
   dart run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   cd apps/mch_health_worker
   flutter run
   ```

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
│       │   │   ├── services/       # Business logic
│       │   │   └── widgets/        # Reusable widgets
│       │   │
│       │   └── features/
│       │       ├── auth/           # Authentication
│       │       ├── dashboard/      # Main dashboard
│       │       └── patient_management/
│       │           ├── data/       # (deprecated - moved to mch_core)
│       │           └── presentation/
│       │               └── screens/  # All UI screens
│       │
│       ├── android/                # Android config
│       ├── windows/                # Windows config
│       └── pubspec.yaml
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
│   └── USER_GUIDE.md
│
├── .gitignore
├── README.md
├── LICENSE
└── pubspec.yaml                    # Root workspace config
```

---

## 🗺️ Development Roadmap

### ✅ Completed (v1.0.0)
- Complete MCH Handbook 2020 digitization
- Offline-first architecture
- 14 major feature modules
- Comprehensive data models
- Patient-provider workflows

### 🔄 In Progress
- [ ] Performance optimization
- [ ] Comprehensive testing suite
- [ ] User acceptance testing

### 📋 Planned Features (v1.1.0)

#### High Priority
- [ ] **Push Notifications**
  - Appointment reminders
  - Immunization due dates
  - Visit scheduling alerts
  
- [ ] **Password Reset**
  - Email-based reset flow
  - Security questions
  - Password strength requirements

- [ ] **WHO Growth Charts**
  - Visual growth curve plotting
  - Z-score calculations
  - Growth trend analysis
  - Malnutrition identification

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

#### Future Enhancements
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

---

## 🙏 Acknowledgments

- **Ministry of Health, Kenya** - For the MCH Handbook 2020 guidelines
- **Flutter Team** - For the amazing framework
- **Supabase** - For the backend infrastructure
- **Open Source Community** - For the incredible packages and tools

---

## 📞 Support

For questions, issues, or support:
- 📧 Email: support@novatcare.com (update with actual email)
- 🐛 Issues: [GitHub Issues](https://github.com/novatcare-prog/nana/issues)
- 📖 Docs: [Documentation](https://github.com/novatcare-prog/nana/wiki)

---

## 🌟 Star History

If this project helps you, please consider giving it a ⭐ on GitHub!

---

## 📊 Project Stats

- **Languages**: Dart, SQL
- **Lines of Code**: ~15,000+
- **Database Tables**: 15+
- **Models**: 20+
- **Screens**: 40+
- **Contributors**: Open for contributions!

---

**Built with ❤️ for better maternal and child healthcare in Kenya**